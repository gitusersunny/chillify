import 'dart:convert';
import 'package:chillify/data/spotifySearchResp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/recommendData.dart';
import '../data/searchReq.dart';
import 'local_storage_service.dart';

class AuthService {
  static const String baseUrl = "https://chillify-apis.onrender.com";
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

  //hit api for wake up server
  static Future<Map<String, dynamic>> wakeUpServer() async {
    final url = Uri.parse("https://chillify-backend.onrender.com/");

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
      },
    );

    return jsonDecode(response.body);
  }


  static Future<RecommendationResponse> getSongRecommendations(String title,String mood) async {
    final url = Uri.parse("https://chillify-backend.onrender.com/recommend");
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "song_name": title,
        "mood": mood,
      }),
    );
    final data = jsonDecode(response.body);
    return RecommendationResponse.fromJson(data);
  }

  static const String token = '28ca3c45-6119-4690-8f44-1f49d663bb94';

 static Future<MusicSearchResponse> searchTrack(MusicSearchRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.musicapi.com/public/search'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Token $token',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return MusicSearchResponse.fromJson(responseData);
      } else {
        throw Exception('Failed to search track: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching track: $e');
    }
  }

}
