import 'package:chillify/ui/recomendation_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';
import '../service/auth_service.dart';
import '../widget/auth_button.dart';
import '../widget/auth_input.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF121212), Color(0xFF1E0E30)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: [
                Icon(Icons.headphones_rounded,
                    size: 80, color: Theme.of(context).hintColor),
                const SizedBox(height: 20),
                Text('Welcome Back!',
                    style: Theme.of(context).textTheme.headlineLarge),
                const SizedBox(height: 40),
                AuthInput(
                    hintText: 'Email Address',
                    icon: Icons.email,controller: emailController),
                const SizedBox(height: 20),
                AuthInput(
                    hintText: 'Password',
                    icon: Icons.lock_outline,
                    isPassword: true,controller: passwordController),
                const SizedBox(height: 30),
                AuthButton(
                  text: 'LOG IN',
                  onPressed: () async {
                    bool resp = await AuthService.login(emailController.text.trim(),passwordController.text.trim());
                    if (resp) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) =>   RecommendationScreen()),
                      );
                    }
                  },
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: (){
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) =>   RecommendationScreen()),
                    );
                  },
                  child: Text(
                    'SKIP',
                    style: TextStyle(
                        color: Theme.of(context).hintColor,
                        fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                const SizedBox(height: 20),
                // Toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? ",
                        style: TextStyle(color: Colors.white70)),
                    GestureDetector(
                      onTap: auth.toggleScreen,
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                            color: Theme.of(context).hintColor,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
