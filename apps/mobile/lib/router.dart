import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/features/authentication/auth_providers.dart';
import 'package:mobile/features/authentication/login_page.dart';
import 'package:mobile/features/home/home_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  // O Router "observa" o userProvider. Qualquer mudança no usuário recria/avalia a rota.
  final userState = ref.watch(userProvider);

  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
    ],
    redirect: (context, state) {
      final isLoggedIn = userState != null;
      final isLoggingIn = state.uri.toString() == '/login';

      if (!isLoggedIn && !isLoggingIn) {
        // Se não está logado e tenta acessar qualquer coisa que não seja login -> Login
        return '/login';
      }

      if (isLoggedIn && isLoggingIn) {
        // Se já está logado e tenta acessar login -> Home
        return '/';
      }

      // Nenhuma ação necessária
      return null;
    },
  );
});