import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neriya/features/authentication/auth_providers.dart';

class MenuPage extends ConsumerWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: Row(
                  children: [
                    const Icon(Icons.arrow_back, color: Colors.black),
                    const SizedBox(width: 8),
                    Text(
                      'BACK',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(),
            
            // Navigation Options
            _MenuOption(
              icon: Icons.home,
              label: 'Home',
              onTap: () {
                context.go('/');
                Navigator.pop(context);
              },
            ),
            _MenuOption(
              icon: Icons.person_add,
              label: 'Add Family',
              onTap: () {
                context.go('/add-family');
                Navigator.pop(context);
              },
            ),
            _MenuOption(
              icon: Icons.add_location_alt,
              label: 'Add Location',
              onTap: () {
                context.go('/add-location');
                Navigator.pop(context);
              },
            ),

            const Spacer(),
            const Divider(),

            // Footer
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: _MenuOption(
                icon: Icons.logout,
                label: 'Sign Out',
                onTap: () {
                  ref.read(authControllerProvider.notifier).signOut();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuOption extends StatelessWidget {
  const _MenuOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(
        label,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      onTap: onTap,
    );
  }
}
