import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import '../../../core/backend/google_signin_service.dart';

class AuthRepository {
  static const _keyToken = 'auth_token';
  static const _keyUserEmail = 'auth_email';

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken) != null;
  }

  Future<String?> currentToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  Future<String?> currentEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserEmail);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.remove(_keyUserEmail);
    // Also sign out of Google if previously signed in.
    try {
      await GoogleSignInService.instance.signOut();
    } catch (_) {}
  }

  /// Mock login: accept any non-empty email/password, generate fake token.
  Future<String> login({required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (email.isEmpty || password.isEmpty) {
      throw AuthException('Email và mật khẩu không được để trống');
    }
    // TODO: Replace with real DDP Accounts.login call later
    final token = 'token_${DateTime.now().millisecondsSinceEpoch}';
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
    await prefs.setString(_keyUserEmail, email);
    return token;
  }

  /// Real Google Sign-In using google_sign_in plugin.
  /// Returns stored token (ID token preferred, else access token).
  Future<String> loginWithGoogle() async {
    try {
      // If already signed in, use existing user; else trigger sign in.
      GoogleSignInAccount? account = GoogleSignInService.instance.currentUser;
      account ??= await GoogleSignInService.instance.signIn();

      if (account == null) {
        throw AuthException('Đăng nhập Google đã bị huỷ');
      }

      final auth = await GoogleSignInService.instance.getAuth(account);
      if (auth == null) {
        throw AuthException('Không lấy được thông tin xác thực Google');
      }

      // Prefer idToken (OpenID Connect) else accessToken as fallback.
      final token = auth.idToken ?? auth.accessToken;
      if (token == null) {
        throw AuthException('Google không trả về token hợp lệ');
      }

      final email = account.email;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyToken, token);
      await prefs.setString(_keyUserEmail, email);
      return token;
    } on AuthException {
      rethrow;
    } catch (e) {
      // Distinguish some common cases
      final message = _mapGoogleError(e);
      throw AuthException(message);
    }
  }

  String _mapGoogleError(Object e) {
    final text = e.toString();
    if (text.contains('network_error')) return 'Lỗi mạng khi kết nối Google';
    if (text.contains('sign_in_canceled')) return 'Bạn đã huỷ đăng nhập';
    if (kDebugMode) {
      return 'Lỗi Google Sign-In: $text';
    }
    return 'Không đăng nhập được với Google';
  }
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
  @override
  String toString() => 'AuthException: $message';
}
