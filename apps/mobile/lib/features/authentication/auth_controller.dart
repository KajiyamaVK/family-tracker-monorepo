import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Manages the state of authentication (User, Loading, Error).
class AuthController extends StateNotifier<AsyncValue<GoogleSignInAccount?>> {
  AuthController(this._googleSignIn) : super(const AsyncValue.data(null));

  final GoogleSignIn _googleSignIn;

  /// Attempts to sign in with Google.
  Future<void> signIn() async {
    state = const AsyncValue.loading();
    try {
      final account = await _googleSignIn.signIn();
      // If the user cancels the login flow, account is null.
      // We check if it is null, but we don't treat cancellation as an error,
      // just a return to the previous state (or null).
      if (account == null) {
        state = const AsyncValue.data(null);
      } else {
        state = AsyncValue.data(account);
      }
    } catch (e, stack) {
      debugPrint('AuthController: Error signing in: $e');
      state = AsyncValue.error(e, stack);
    }
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      await _googleSignIn.disconnect();
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      debugPrint('AuthController: Error signing out: $e');
      state = AsyncValue.error(e, stack);
    }
  }
}