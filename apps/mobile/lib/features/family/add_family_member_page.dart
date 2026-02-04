import 'package:flutter/material.dart';

class AddFamilyMemberPage extends StatelessWidget {
  const AddFamilyMemberPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Family Member'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement send logic
                },
                child: const Text('Send'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
