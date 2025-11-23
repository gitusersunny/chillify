import 'package:flutter/material.dart';

class AuthInput extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final bool isPassword;
  final TextEditingController controller;

  AuthInput({
    required this.hintText,
    required this.icon,
    this.isPassword = false,
    required this.controller
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
        prefixIcon: Icon(
          icon,
          color: Theme.of(context).primaryColor, // Use primary color for icons
        ),
      ),
    );
  }
}