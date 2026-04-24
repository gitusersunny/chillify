import 'dart:convert';
import 'package:http/http.dart' as http;

class MusicService {
  // Using a public Piped instance (Alternative: https://pipedapi.kavin.rocks)
  static const String apiBase = "https://pipedapi.kavin.rocks";

  static Future<String?> getStreamUrl(String trackName) async {
    try {
      // 1. Search for the track
      final searchUrl = Uri.parse("$apiBase/search?q=${Uri.encodeComponent(trackName)}&filter=music_songs");
      final searchRes = await http.get(searchUrl);

      if (searchRes.statusCode != 200) return null;
      final searchData = jsonDecode(searchRes.body);

      if (searchData['items'].isEmpty) return null;

      // 2. Get the Video ID from the first result
      // The URL format is usually "/watch?v=XXXXXX"
      final String videoUrl = searchData['items'][0]['url'];
      final String videoId = videoUrl.split("v=")[1];

      // 3. Get the actual audio stream
      final streamUrl = Uri.parse("$apiBase/streams/$videoId");
      final streamRes = await http.get(streamUrl);

      if (streamRes.statusCode == 200) {
        final streamData = jsonDecode(streamRes.body);
        // Return the first audio-only stream link
        return streamData['audioStreams'][0]['url'];
      }
    } catch (e) {
      print("Stream Error: $e");
    }
    return null;
  }
}