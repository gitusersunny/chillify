import 'package:chillify/service/auth_service.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _showLogin = true;

  bool get showLogin => _showLogin;

  final RegExp emailRegex = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  );

  bool isValidEmail(String email) {
    return emailRegex.hasMatch(email);
  }

  void toggleScreen() {
    _showLogin = !_showLogin;
    notifyListeners();
  }

    Future<bool> registerUser(name,email,password) async{
    return AuthService.register(name, email, password);
  }

}
