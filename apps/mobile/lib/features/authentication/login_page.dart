import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neriya/features/authentication/auth_providers.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  static const double _padding = 24.0;
  static const double _logoSize = 120.0;
  static const double _iconSize = 64.0;
  static const double _spacingSmall = 8.0;
  static const double _spacingMedium = 24.0;
  static const double _spacingLarge = 48.0;
  static const double _buttonHeight = 16.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen for errors to show SnackBar (fulfilling the TODO)
    ref.listen(authControllerProvider, (previous, next) {
      if (next.hasError && !next.isLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao entrar: ${next.error}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    });

    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(_padding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Placeholder
              Container(
                width: _logoSize,
                height: _logoSize,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.family_restroom_rounded,
                  size: _iconSize,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: _spacingMedium),

              // App Title
              Text(
                'Family Tracker',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: _spacingSmall),
              Text(
                'Mantenha sua família segura e conectada.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: _spacingLarge),

              // Google Sign In Button
              if (authState.isLoading)
                const CircularProgressIndicator()
              else
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      ref.read(authControllerProvider.notifier).signIn();
                    },
                    icon: const Icon(Icons.login_rounded),
                    label: const Text('Entrar com Google'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: _buttonHeight,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}