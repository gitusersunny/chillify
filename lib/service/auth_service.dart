import 'dart:convert';
import 'package:chillify/data/spotifySearchResp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/recommendData.dart';
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

  static void getSpotifyToken() async {
    final url = Uri.parse("https://accounts.spotify.com/api/token");

    final headers = {
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": "Basic ${base64Encode(utf8.encode("9bb9139991cf4ec5aac2f27bcc1038f7:cb6db17826f94dca9aaafa5db4cf9bf6"))}",
    };

    final body = {
      "grant_type": "client_credentials",
    };

    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("spotify_token", data["access_token"]);
    }

    print("Error: ${response.statusCode} - ${response.body}");
  }

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


  static Future<RecommendationResponse> getSongRecommendations(String title) async {
    final url = Uri.parse("https://chillify-backend.onrender.com/recommend");
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "song_name": title,
      }),
    );
    final data = jsonDecode(response.body);
    return RecommendationResponse.fromJson(data);
  }

  static Future<SpotifySearchResponse?> searchSpotifyTrack(String query, String token) async {
    final url = Uri.parse(
        "https://api.spotify.com/v1/search?offset=0&limit=1&query=$query&type=track");

    final headers = {
      "Authorization": "Bearer $token",
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return SpotifySearchResponse.fromJson(data);
    } else {
      print("Error: ${response.statusCode} - ${response.body}");
      return null;
    }
  }

}
