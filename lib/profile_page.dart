// ignore: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart'; // Adjust if your file structure is different

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get current user data
    final user = context.watch<AuthService>().currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => context.read<AuthService>().signOut(),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (user != null) ...[
              // Display user info if logged in
              CircleAvatar(
                backgroundImage: NetworkImage(user.photoURL ?? ''),
                radius: 50.0,
              ),
              const SizedBox(height: 10),
              Text(
                'Name: ${user.displayName ?? 'No name provided'}',
                style: const TextStyle(fontSize: 20),
              ),
              Text(
                'Email: ${user.email ?? 'No email provided'}',
                style: const TextStyle(fontSize: 18),
              ),
            ] else ...[
              // Display message if no user is logged in
              const Text(
                'No user is signed in',
                style: TextStyle(fontSize: 20),
              ),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.read<AuthService>().signOut(),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
