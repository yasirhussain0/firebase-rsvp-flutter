// lib/main.dart

// ignore_for_file: depend_on_referenced_packages

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'home_page.dart';
import 'services/auth_service.dart';
import 'pages/auth_page.dart';
import 'services/firestore_service.dart' show FirestoreService;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    // Wrap the app with MultiProvider
    MultiProvider(
      providers: [
        Provider(create: (_) => AuthService()),
        Provider(create: (_) => FirestoreService()), // Add FirestoreService
      ],
      child: const MyApp(),
    ),
  );
}

// Router configuration
final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      redirect: (context, state) {
        final user = FirebaseAuth.instance.currentUser;
        return user == null ? '/auth' : '/home';
      },
    ),
    GoRoute(
      path: '/auth',
      name: 'auth',
      builder: (context, state) => const AuthPage(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Show loading indicator if the auth state is still loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        // After the auth state is ready, proceed with the app's router
        return MaterialApp.router(
          title: 'Firebase Meetup',
          debugShowCheckedModeBanner: false,
          routerConfig: _router,
          theme: ThemeData(
            buttonTheme: Theme.of(context).buttonTheme.copyWith(
                  highlightColor: Colors.deepPurple,
                ),
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
            visualDensity: VisualDensity.adaptivePlatformDensity,
            useMaterial3: true,
          ),
        );
      },
    );
  }
}
