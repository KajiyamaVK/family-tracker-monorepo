import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/features/authentication/auth_providers.dart';
import 'package:mobile/features/authentication/login_page.dart';
import 'package:mobile/features/family/add_family_member_page.dart';
import 'package:mobile/features/home/home_page.dart';
import 'package:mobile/features/location/add_location_page.dart';
import 'package:mobile/features/map/presentation/map_page.dart';
import 'package:mobile/features/menu/menu_page.dart';
import 'package:mobile/features/navigation/scaffold_with_nav_bar.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  // O Router "observa" o authControllerProvider.
  // Qualquer mudança no estado (Login, Logout, Loading, Error) reavalia a rota.
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      // StatefulShellRoute para a Bottom Navigation Bar
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          // Branch 1: Home
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const HomePage(),
                routes: [
                  GoRoute(
                    path: 'map',
                    builder: (context, state) => const MapPage(),
                  ),
                ],
              ),
            ],
          ),
          // Branch 2: Add Family Member
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/add-family',
                builder: (context, state) => const AddFamilyMemberPage(),
              ),
            ],
          ),
          // Branch 3: Add Location
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/add-location',
                builder: (context, state) => const AddLocationPage(),
              ),
            ],
          ),
          // Branch 4: Menu
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/menu',
                builder: (context, state) => const MenuPage(),
              ),
            ],
          ),
        ],
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