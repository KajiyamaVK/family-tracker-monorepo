import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Provider para injetar a instância do GoogleSignIn (facilita mocks nos testes)
final googleSignInProvider = Provider<GoogleSignIn>((ref) => GoogleSignIn());

// Provider para gerenciar o estado do usuário logado
final userProvider = StateProvider<GoogleSignInAccount?>((ref) => null);