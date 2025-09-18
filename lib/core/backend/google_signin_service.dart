import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import '../config/google_oauth_ids.dart';

class GoogleSignInService {
  GoogleSignInService._();
  static final instance = GoogleSignInService._();

  // Initialize GoogleSignIn with platform-specific clientId logic.
  // - iOS: must provide the iOS client id (or use GoogleService-Info.plist when using Firebase).
  // - Android: null (auto config via google-services.json if using Firebase; manual clientId not required for most flows).
  // - Web / other: use web client id.
  late final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: switch (defaultTargetPlatform) {
      TargetPlatform.iOS => GoogleOAuthIds.iosClientId,
      TargetPlatform.macOS => GoogleOAuthIds.iosClientId, // reuse iOS client if you test on macOS
      TargetPlatform.android => null,
      _ => GoogleOAuthIds.webClientId,
    },
    serverClientId: GoogleOAuthIds.webClientId, // for retrieving server auth code / idToken audience
    scopes: const [
      'email',
      'profile',
      'openid', // ensure idToken includes standard claims
    ],
  );

  GoogleSignInAccount? get currentUser => _googleSignIn.currentUser;

  Future<GoogleSignInAccount?> signIn() async {
    try {
      return await _googleSignIn.signIn();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
  }

  Future<GoogleSignInAuthentication?> getAuth(GoogleSignInAccount account) async {
    try {
      return await account.authentication;
    } catch (e) {
      rethrow;
    }
  }
}
