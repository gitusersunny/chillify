import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import '../ui/login_screen.dart';
import '../ui/register_screen.dart';

class MusicAuthApp extends StatelessWidget {
  const MusicAuthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vibe Music Auth',
      theme: ThemeData(
        // Dark theme is perfect for a music app UI
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212), // Very dark background
        primaryColor: const Color(0xFFBB86FC), // Primary accent purple
        hintColor: const Color(0xFF03DAC6), // Secondary accent teal/cyan
        fontFamily: 'Inter', // Custom font (requires setup, using default for preview)
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF282828), // Darker grey input field
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0),
          labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFBB86FC), // Primary button color
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
        ),
        textTheme: TextTheme(
          headlineLarge: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 32,
            letterSpacing: 1.2,
          ),
          bodyMedium: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 16,
          ),
        ),
      ),
      home: AuthFlowManager(), // Start with the manager to handle screen switching
    );
  }
}

class AuthFlowManager extends StatelessWidget {
  AuthFlowManager({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        return auth.showLogin
            ? LoginScreen()
            : RegisterScreen();
      },
    );
  }
}
