import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Future<void> _handleGoogleSignIn() async {
    try {
      final googleSignIn = GoogleSignIn();
      final account = await googleSignIn.signIn();
      
      if (account != null) {
        // TODO(dev): Implementar lógica de navegação ou envio de token para o backend
        debugPrint('Usuário logado: ${account.email}');
      }
    } catch (error) {
      debugPrint('Erro no login Google: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
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
                  onPressed: _handleGoogleSignIn,
                  icon: const Icon(Icons.login_rounded),
                  label: const Text('Entrar com Google'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
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