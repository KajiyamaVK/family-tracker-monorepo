import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/features/authentication/auth_providers.dart';
import 'package:mobile/features/authentication/login_page.dart';
import 'package:mobile/features/home/home_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  // O Router "observa" o authControllerProvider.
  // Qualquer mudança no estado (Login, Logout, Loading, Error) reavalia a rota.
  final authState = ref.watch(authControllerProvider);

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
      final isLoggedIn = authState.value != null;
      final isLoggingIn = state.uri.toString() == '/login';

      // Enquanto estiver carregando (ex: tentando logar), não redirecionamos bruscamente,
      // deixamos a UI de loading do LoginPage lidar com isso, ou podemos impedir navegação.
      // Aqui focamos apenas no estado final 'value'.

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