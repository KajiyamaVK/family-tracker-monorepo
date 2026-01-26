import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Provider para injetar a instância do GoogleSignIn (facilita mocks nos testes)
final googleSignInProvider = Provider<GoogleSignIn>((ref) => GoogleSignIn());

// Provider para gerenciar o estado do usuário logado
final userProvider = StateProvider<GoogleSignInAccount?>((ref) => null);

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  Future<void> _handleGoogleSignIn(WidgetRef ref) async {
    try {
      // Obtém a instância do provider (pode ser mockada)
      final googleSignIn = ref.read(googleSignInProvider);
      final account = await googleSignIn.signIn();

      if (account != null) {
        // Atualiza o estado global do usuário
        ref.read(userProvider.notifier).state = account;
        debugPrint('Usuário logado: ${account.email}');
      }
    } catch (error) {
      debugPrint('Erro no login Google: $error');
    }
  }

  Future<void> _handleSignOut(WidgetRef ref) async {
    try {
      final googleSignIn = ref.read(googleSignInProvider);
      await googleSignIn.disconnect();
      ref.read(userProvider.notifier).state = null;
    } catch (error) {
      debugPrint('Erro ao deslogar: $error');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Observa o estado do usuário
    final user = ref.watch(userProvider);

    return Scaffold(
      body: Center(
        child: user != null
            ? _buildUserProfile(context, ref, user)
            : _buildLoginView(context, ref),
      ),
    );
  }

  Widget _buildUserProfile(
      BuildContext context, WidgetRef ref, GoogleSignInAccount user) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (user.photoUrl != null)
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(user.photoUrl!),
            )
          else
            const Icon(Icons.account_circle, size: 80, color: Colors.grey),
          const SizedBox(height: 24),
          Text(
            user.displayName ?? 'Usuário sem nome',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            user.email,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 48),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _handleSignOut(ref),
              icon: const Icon(Icons.logout),
              label: const Text('Sair'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginView(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo Placeholder
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.family_restroom_rounded,
              size: 64,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 24),

          // App Title
          Text(
            'Family Tracker',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Mantenha sua família segura e conectada.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 48),

          // Google Sign In Button
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => _handleGoogleSignIn(ref),
              icon: const Icon(Icons.login_rounded),
              label: const Text('Entrar com Google'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}