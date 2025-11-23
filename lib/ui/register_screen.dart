import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import '../widget/auth_button.dart';
import '../widget/auth_input.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E0E30), Color(0xFF121212)],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: [
                Text(
                  'Create Your Vibe Account',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 40),
                AuthInput(
                    hintText: 'Full Name', icon: Icons.person_outline,controller: nameController),
                const SizedBox(height: 20),
                AuthInput(
                    hintText: 'Email Address', icon: Icons.email_outlined,controller: emailController,),
                const SizedBox(height: 20),
                AuthInput(
                    hintText: 'Create Password',
                    icon: Icons.lock_outline,
                    isPassword: true,controller: passwordController),
                const SizedBox(height: 30),
                AuthButton(text: 'SIGN UP', onPressed: () async {
                  if(auth.isValidEmail( emailController.text.trim())){
                    bool resp = await auth.registerUser(
                        nameController.text.trim(),
                        emailController.text.trim(),
                        passwordController.text.trim());
                    if(resp) auth.toggleScreen();
                  }else{
                    Fluttertoast.showToast(msg: "Invalid Email Address");
                  }
                }),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? ",
                        style: TextStyle(color: Colors.white70)),
                    GestureDetector(
                      onTap: auth.toggleScreen,
                      child: Text(
                        'Log In',
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
