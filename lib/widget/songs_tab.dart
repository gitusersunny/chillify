import 'package:flutter/material.dart';

class SongsTab extends StatefulWidget {
    SongsTab({super.key});

  @override
  State<SongsTab> createState() => _MusicListPageState();
}

class _MusicListPageState extends State<SongsTab> {
  List<Map<String, dynamic>> songs = [
    {
      "id": 1,
      "title": "Kesariya",
      "artist": "Arijit Singh",
      "image":
      "https://wallpapers.com/images/featured/arijit-singh-pictures-q307hnimzo1z26ct.jpg",
      "isPlaying": false,
    },
    {
      "id": 2,
      "title": "Sun Raha Hai",
      "artist": "Shreya Ghoshal",
      "image":
      "https://i.pinimg.com/736x/37/98/8e/37988ed10b22e3743578e691e6bee0a2.jpg",
      "isPlaying": false,
    },
  ];

  int? currentlyPlayingId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Music List"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          final song = songs[index];
          bool isPlaying = song["id"] == currentlyPlayingId;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: isPlaying
                    ? LinearGradient(
                  colors: [
                    Colors.blue.shade200,
                    Colors.purple.shade200,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
                    : null,
                color: !isPlaying
                    ? Colors.grey.shade200
                    : null, // fallback color when not playing
                boxShadow: isPlaying
                    ? [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.4),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
                    : [],
              ),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    song["image"],
                    width: 55,
                    height: 55,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  song["title"],
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  song["artist"],
                  style: const TextStyle(fontSize: 14),
                ),
                trailing: IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause_circle : Icons.play_circle,
                    size: 32,
                    color: Colors.black87,
                  ),
                  onPressed: () {
                    setState(() {
                      if (isPlaying) {
                        currentlyPlayingId = null;
                      } else {
                        currentlyPlayingId = song["id"];
                      }
                    });
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
