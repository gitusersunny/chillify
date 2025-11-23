import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'local_storage_service.dart';

class AuthService {
  static const String baseUrl = "http://10.0.2.2:5000";
  // For Android Emulator use 10.0.2.2 instead of localhost

  static Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if(data["success"]){
          LocalStorageService.saveLogin(true);
        }
        Fluttertoast.showToast(msg: data["message"]);
        return data["success"];
      } else if(response.statusCode == 401) {
        Fluttertoast.showToast(msg: data["message"]);
        return false;
      }else{
        Fluttertoast.showToast(msg: "Server error");
        return false;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
      return false;
    }
  }

  static Future<bool> register(String name,String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name" : name,
          "email": email,
          "password": password,
        }),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: data["message"]);
        return data["success"];
      } else if(response.statusCode == 401) {
        Fluttertoast.showToast(msg: data["message"]);
        return false;
      }else{
        Fluttertoast.showToast(msg: "Server error");
        return false;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
      return false;
    }
  }
}
