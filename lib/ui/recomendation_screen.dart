import 'package:flutter/material.dart';
import '../data/mood.dart';
import '../data/recommendData.dart';
import '../data/searchReq.dart';
import '../service/auth_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:just_audio/just_audio.dart' as gap;

class RecommendationScreen extends StatefulWidget {
  const RecommendationScreen({super.key});

  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  RecommendationResponse? songs;
  bool opening = false;
  TextEditingController searchController = TextEditingController();
  final gap.AudioPlayer player = gap.AudioPlayer();

  fetchSongs(String title,String mood) async {
    if (title.trim().isEmpty) return;
    showConnectingDialog(context,"Fetching songs for you...please wait a while"); // your dialog function
      songs = await AuthService.getSongRecommendations(title);
      Navigator.of(context, rootNavigator: true).pop();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showConnectingDialog(context,"Connecting to server...please wait a while"); // your dialog function
      wakeUpServer();
    });
  }

  void wakeUpServer() async{
    Map<String, dynamic> res = await AuthService.wakeUpServer();
    if (res.isNotEmpty){
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  void requestForSearch(song,artist) async{
    final request = MusicSearchRequest(
      track: song,
      artist: artist,
      type: 'track',
      sources: ['spotify'],
    );

    final result = await AuthService.searchTrack(request);
    openSpotifyDynamic(result.tracks[0].data.url);
  }
  
  Future<void> openSpotifyDynamic(String url) async {
    try {
      final Uri uri = Uri.parse(url);

      // Example path: /track/{id} OR /album/{id} OR /playlist/{id}
      final segments = uri.pathSegments;

      if (segments.length < 2) {
        throw Exception("Invalid Spotify URL");
      }

      final type = segments[0]; // track / album / playlist
      final id = segments[1];

      // Build deep link
      final Uri appUri = Uri.parse("spotify:$type:$id");

      // Try opening Spotify app
      if (await canLaunchUrl(appUri)) {
        await launchUrl(appUri);
      } else {
        // fallback to browser
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      print("Error opening Spotify: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: Text(
                "Chillify : Your Music Recommender",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                showMoodDialog(context);
              },
              icon: Image.asset(
                'assets/images/mood.png',
                width: 34,
                height: 34,
              ),
            ),
          ],
        ),
          bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                // 🔍 Search TextField
                Expanded(
                  child: TextField(
                    controller: searchController,
                    onSubmitted: (value) => fetchSongs(value,"sample"), // 🔥 call API on Enter
                    decoration: InputDecoration(
                      hintText: "Search song name...",
                      prefixIcon: Icon(Icons.search,color: Colors.white),
                      filled: true,
                      fillColor: Colors.white10,
                      contentPadding: EdgeInsets.symmetric(horizontal: 15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 10),

                // ▶ Search Button
                ElevatedButton(
                  onPressed: () => fetchSongs(searchController.text,"sample"), // 🔥 call API on button press
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(14),
                  ),
                  child: Icon(Icons.send,color: Colors.white,)
                )
              ],
            ),
          ),
        ),
      ),

      body:
         Stack(
           children: [
          (songs != null && songs!.success == false)
          ? Center(
        child: Text(
          "Oops.. No song found with this name.",
          style: TextStyle(fontSize: 20, color: Colors.redAccent),
        ),
      )
          : songs == null
          ? Center(
        child: Text(
          "Type a song name and search!",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ⭐ SEARCHED SONG SECTION ⭐
          if (songs != null &&
              songs!.recommendations.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15),
                  Text(
                    "Recommended Songs",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

          // ⭐ RECOMMEND LIST (excluding index 0)
          Expanded(
            child: ListView.builder(
              itemCount: songs!.recommendations.length,
              itemBuilder: (context, i) {
                final s = songs!.recommendations[i];

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: const Icon(Icons.music_note, size: 40),

                    title: Text(
                      s.trackName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),

                    subtitle: Text(
                      s.artists,
                      style: TextStyle(color: Colors.grey[700]),
                    ),

                    trailing: const Icon(Icons.arrow_forward_ios),
                     // In your Widget
                    onTap: () async {
                      requestForSearch( s.trackName.toLowerCase(),s.artists.toLowerCase());
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
             if (opening)
               Center(child: CircularProgressIndicator())
           ],
         )
    );
  }



  void showConnectingDialog(BuildContext context,String text) {
    showDialog(
      context: context,
      barrierDismissible: false, // user cannot close the dialog manually
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const CircularProgressIndicator(),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<Mood?> showMoodDialog(BuildContext context) {
    return showDialog<Mood>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select your mood 🎧"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: moods.map((mood) {
              return Card(
                color: mood.color.withOpacity(0.15),
                child: ListTile(
                  leading: Text(
                    mood.emoji,
                    style: const TextStyle(fontSize: 24),
                  ),
                  title: Text(
                    mood.name[0].toUpperCase() + mood.name.substring(1),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: mood.color,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context, mood);
                    fetchSongs("sample",mood.name.toLowerCase());
                  },
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
