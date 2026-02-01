import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/features/authentication/auth_providers.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  static const double _padding = 24.0;
  static const double _avatarRadius = 50.0;
  static const double _avatarIconSize = 100.0;
  static const double _avatarBorderWidth = 3.0;
  static const double _spacingSmall = 8.0;
  static const double _spacingMedium = 24.0;
  static const double _spacingLarge = 48.0;
  static const double _emailPaddingH = 12.0;
  static const double _emailPaddingV = 6.0;
  static const double _emailRadius = 20.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final user = authState.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(authControllerProvider.notifier).signOut();
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
          ),
        ],
      ),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(_padding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (user.photoUrl != null)
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: _avatarBorderWidth,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: _avatarRadius,
                          backgroundImage: NetworkImage(user.photoUrl!),
                        ),
                      )
                    else
                      const Icon(
                        Icons.account_circle,
                        size: _avatarIconSize,
                        color: Colors.grey,
                      ),
                    const SizedBox(height: _spacingMedium),
                    Text(
                      'Bem-vindo,',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      user.displayName ?? 'Usuário',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: _spacingSmall),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: _emailPaddingH,
                        vertical: _emailPaddingV,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(_emailRadius),
                      ),
                      child: Text(
                        user.email,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontFamily: 'monospace',
                            ),
                      ),
                    ),
                    const SizedBox(height: _spacingLarge),
                    const Divider(),
                    const SizedBox(height: 16),
                    Text(
                      'ID do Google:',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      user.id,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: () {
                        context.push('/map');
                      },
                      icon: const Icon(Icons.map),
                      label: const Text('Abrir Mapa'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}