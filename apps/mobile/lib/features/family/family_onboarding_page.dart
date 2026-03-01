
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neriya/features/family/family_provider.dart';

class FamilyOnboardingPage extends ConsumerStatefulWidget {
  const FamilyOnboardingPage({super.key});

  @override
  ConsumerState<FamilyOnboardingPage> createState() => _FamilyOnboardingPageState();
}

class _FamilyOnboardingPageState extends ConsumerState<FamilyOnboardingPage> {
  final _otpController = TextEditingController();

  bool _isJoining = false;

  @override
  Widget build(BuildContext context) {
    final familyState = ref.watch(familyControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Family Setup')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (familyState.isLoading)
                const CircularProgressIndicator()
              else ...[
                const Text(
                  'Welcome! To start, you need to be part of a family.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 32),
                
                // CREATE FAMILY OPTION
                ElevatedButton.icon(
                  onPressed: () {
                    // Simple mock creation flow
                    ref.read(familyControllerProvider.notifier).createFamily("My Family");
                  },
                  icon: const Icon(Icons.add_home),
                  label: const Text('Create a New Family'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
                
                const SizedBox(height: 24),
                const Text("- OR -"),
                const SizedBox(height: 24),

                // JOIN FAMILY OPTION
                if (!_isJoining)
                  OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        _isJoining = true;
                      });
                    },
                    icon: const Icon(Icons.group_add),
                    label: const Text('Join an Existing Family'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  )
                else
                  Column(
                    children: [
                      TextField(
                        controller: _otpController,
                        decoration: const InputDecoration(
                          labelText: 'Enter Invite Code',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  _isJoining = false;
                                });
                              },
                              child: const Text('Cancel'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                final otp = _otpController.text.trim();
                                if (otp.isNotEmpty) {
                                  ref.read(familyControllerProvider.notifier).joinFamily(otp);
                                }
                              },
                              child: const Text('Join'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                if (familyState.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      'Error: ${familyState.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
