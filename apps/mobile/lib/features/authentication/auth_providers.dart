import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobile/features/authentication/auth_controller.dart';

// Provider to inject the GoogleSignIn instance (facilitates mocks in tests)
final googleSignInProvider = Provider<GoogleSignIn>((ref) => GoogleSignIn());

// Controller Provider that manages the authentication logic and state
final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<GoogleSignInAccount?>>(
        (ref) {
  final googleSignIn = ref.watch(googleSignInProvider);
  return AuthController(googleSignIn);
});