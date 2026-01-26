import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/authentication/auth_providers.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  Future<void> _handleSignOut(WidgetRef ref) async {
    try {
      final googleSignIn = ref.read(googleSignInProvider);
      await googleSignIn.disconnect();
      ref.read(userProvider.notifier).state = null;
      // O redirecionamento será automático pelo Router
    } catch (error) {
      debugPrint('Erro ao deslogar: $error');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () => _handleSignOut(ref),
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
          ),
        ],
      ),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (user.photoUrl != null)
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 3,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(user.photoUrl!),
                        ),
                      )
                    else
                      Icon(Icons.account_circle, size: 100, color: Colors.grey),
                    const SizedBox(height: 24),
                    Text(
                      'Bem-vindo,',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      user.displayName ?? 'Usuário',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        user.email,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontFamily: 'monospace',
                            ),
                      ),
                    ),
                    const SizedBox(height: 48),
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
                  ],
                ),
              ),
            ),
    );
  }
}