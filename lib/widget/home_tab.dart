import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  HomeTab({super.key});

  final List<Map<String, String>> topSongs = List.generate(
    20,
        (index) => {
      "title": "Song ${index + 1}",
      "image": "https://www.shutterstock.com/image-illustration/music-themed-thumbnail-260nw-1125825572.jpg",
    },
  );

  final List<Map<String, String>> topArtists = [
    {
      "name": "Arijit Singh",
      "image": "https://wallpapers.com/images/featured/arijit-singh-pictures-q307hnimzo1z26ct.jpg"
    },
    {
      "name": "Shreya Ghoshal",
      "image": "https://i.pinimg.com/736x/37/98/8e/37988ed10b22e3743578e691e6bee0a2.jpg"
    },
    {
      "name": "Sid Sriram",
      "image": "https://i.pinimg.com/736x/fd/b2/f9/fdb2f984b7ad68936faef2609c60a9e7.jpg"
    },
    {
      "name": "Anirudh",
      "image": "https://i.pinimg.com/originals/48/2a/40/482a4000cf619cb855324ba6c43cabe7.jpg"
    },
    {
      "name": "Armaan Malik",
      "image": "https://upload.wikimedia.org/wikipedia/commons/1/15/Armaan_Malik_2016.jpg"
    },
  ];

  final List<Map<String, String>> recentRelease = List.generate(
    5,
        (index) => {
      "title": "Song ${index + 1}",
      "image": "https://www.shutterstock.com/image-illustration/music-themed-thumbnail-260nw-1125825572.jpg",
    },
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chillify....👉 🖤"),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TOP SONGS
              sectionTitle("Recently Released 🎧"),
              const SizedBox(height: 10),

              SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: topSongs.length,
                  itemBuilder: (context, index) {
                    return itemCard(
                      topSongs[index]["image"]!,
                      topSongs[index]["title"]!,
                    );
                  },
                ),
              ),

              const SizedBox(height: 10),

              // ARTISTS
              sectionTitle("Top Artists ❤️‍🔥"),
              const SizedBox(height: 10),

              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: topArtists.length,
                  itemBuilder: (context, index) {
                    return artistCard(
                      topArtists[index]["image"]!,
                      topArtists[index]["name"]!,
                    );
                  },
                ),
              ),

              const SizedBox(height: 10),

              // Recently Released
              sectionTitle("Top Ten ⭐"),
              const SizedBox(height: 10),

              SizedBox(
                height: 180,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: recentRelease.length,
                  itemBuilder: (context, index) {
                    return itemCard(
                      recentRelease[index]["image"]!,
                      recentRelease[index]["title"]!,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- Widget for Section Title ----------
  Widget sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // ---------- Widget for Song / Release Cards ----------
  Widget itemCard(String imageUrl, String title) {
    return Container(
      width: 130,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(imageUrl, height: 120, width: 130, fit: BoxFit.cover),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  // ---------- Widget for Artist Cards ----------
  Widget artistCard(String img, String name) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          ClipOval(
            child: FadeInImage(
              placeholder: AssetImage("assets/music_cover.png"),
              image: NetworkImage(img),
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
