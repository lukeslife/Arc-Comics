import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to Arc Comics v2!'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go('/library'),
              child: const Text('Enter Library'),
            ),
          ],
        ),
      ),
    );
  }
}
