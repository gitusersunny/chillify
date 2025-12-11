import 'package:chillify/data/spotifySearchResp.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/recommendData.dart';
import '../service/auth_service.dart';
import 'package:url_launcher/url_launcher.dart';

class RecommendationScreen extends StatefulWidget {
  const RecommendationScreen({super.key});

  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  RecommendationResponse? songs;
  bool opening = false;
  AudioPlayer player = AudioPlayer();

  TextEditingController searchController = TextEditingController();

  fetchSongs(String title) async {
    if (title.trim().isEmpty) return;
    showConnectingDialog(context,"Fetching songs for you...please wait a while"); // your dialog function
      songs = await AuthService.getSongRecommendations(title);
      Navigator.of(context, rootNavigator: true).pop();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    AuthService.getSpotifyToken();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chillify : Your Music Recommender",style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        )),
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
                    onSubmitted: (value) => fetchSongs(value), // 🔥 call API on Enter
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
                  onPressed: () => fetchSongs(searchController.text), // 🔥 call API on button press
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
          (songs != null && songs!.recommendations.success == false)
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
          if (songs!.recommendations.recommendations.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "You searched for",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Card(
                    elevation: 3,
                    child: ListTile(
                      leading: Icon(Icons.music_note, size: 40, color: Colors.purple),
                      title: Text(
                        songs!.recommendations.recommendations[0].trackName,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        songs!.recommendations.recommendations[0].artists,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        openSpotify(songs!.recommendations.recommendations[0].trackName);
                      },
                    ),
                  ),

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
              itemCount: songs!.recommendations.recommendations.length - 1,
              itemBuilder: (context, i) {
                final s = songs!.recommendations.recommendations[i + 1];

                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    leading: Icon(Icons.music_note, size: 40),

                    title: Text(
                      s.trackName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    subtitle: Text(
                      s.artists,
                      style: TextStyle(color: Colors.grey[700]),
                    ),

                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () => openSpotify(s.trackName),

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

  Future<void> openSpotify(String trackName) async {

    setState(() => opening = true);

    final token = (await SharedPreferences.getInstance()).getString("spotify_token");

   SpotifySearchResponse? res = await AuthService.searchSpotifyTrack(trackName,token ?? "");

   if (res!=null){
     Future.microtask(() async {
       final uri = Uri.parse(res.tracks.items[0].uri);
       if (await canLaunchUrl(uri)) {
         await launchUrl(uri, mode: LaunchMode.externalApplication);
       } else {
         final webUrl = Uri.parse(res.tracks.items[0].externalUrls.spotify);
         await launchUrl(webUrl, mode: LaunchMode.externalApplication);
       }
     });
   }
    if (mounted) {
      setState(() => opening = false);
    }
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

}
