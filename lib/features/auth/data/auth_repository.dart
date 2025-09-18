import 'package:shared_preferences/shared_preferences.dart';

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
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
  @override
  String toString() => 'AuthException: $message';
}
