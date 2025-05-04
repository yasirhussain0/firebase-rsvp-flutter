// lib/router.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Import your pages
import 'home_page.dart';
import 'pages/auth_page.dart';   // Ensure this file exists
// Ensure this file exists
// Ensure this file exists

final GoRouter router = GoRouter(
  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;
    final isAuthPage = state.uri.toString().startsWith('/auth');

    // If not logged in, redirect to auth page unless already there
    if (user == null && !isAuthPage) return '/auth';

    // If logged in and trying to go to auth page, redirect to home
    if (user != null && isAuthPage) return '/';

    // No redirect needed
    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/auth',
      name: 'auth',
      builder: (context, state) => const AuthPage(),
    ),
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => const ProfilePage(),
    ),
  ],
);

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
      ),
      body: const Center(
        child: Text('Welcome to the Profile Page!'),
      ),
    );
  }
}
