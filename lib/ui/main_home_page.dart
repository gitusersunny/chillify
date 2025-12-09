import 'package:chillify/ui/recomendation_screen.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: RecommendationScreen(),
  ));
}

class MainHomePage extends StatefulWidget {
  const MainHomePage({super.key});

  @override
  State<MainHomePage> createState() => _MusicListPageState();
}

class _MusicListPageState extends State<MainHomePage> {
  final AudioPlayer _player = AudioPlayer();

  // Tracks currently selected music
  ValueNotifier<Map<String, dynamic>?> currentSong = ValueNotifier(null);

  List<Map<String, dynamic>> songs = [
    {
      "id": 1,
      "title": "Kesariya",
      "artist": "Arijit Singh",
      "url":
      "https://samplelib.com/lib/preview/mp3/sample-6s.mp3", // Sample audio
      "image":
      "https://upload.wikimedia.org/wikipedia/en/6/6e/Kesariya_song_poster.jpg",
    },
    {
      "id": 2,
      "title": "Sun Raha Hai",
      "artist": "Shreya Ghoshal",
      "url": "https://samplelib.com/lib/preview/mp3/sample-3s.mp3",
      "image":
      "https://upload.wikimedia.org/wikipedia/en/f/f3/Aashiqui_2.jpg",
    },
  ];

  @override
  void initState() {
    super.initState();
    _setupAudioSession();
  }

  Future<void> _setupAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
  }

  Future<void> playSong(Map<String, dynamic> song) async {
    try {
      await _player.setUrl(song["url"]);
      _player.play();
      currentSong.value = song;
    } catch (e) {
      debugPrint("Error loading song: $e");
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Music Player"),
        centerTitle: true,
      ),

      // ---------------- SONG LIST ----------------
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, index) {
                final song = songs[index];
                final isPlaying =
                    currentSong.value?["id"] == song["id"] && _player.playing;

                return ListTile(
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
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
                        fontWeight: FontWeight.w600, fontSize: 17),
                  ),
                  subtitle: Text(song["artist"]),
                  trailing: Icon(
                    isPlaying ? Icons.pause_circle : Icons.play_circle,
                    size: 32,
                    color: Colors.blue,
                  ),
                  onTap: () {
                    if (isPlaying) {
                      _player.pause();
                    } else {
                      playSong(song);
                    }
                  },
                );
              },
            ),
          ),

          // ---------------- BOTTOM PLAYER BAR ----------------
          ValueListenableBuilder(
            valueListenable: currentSong,
            builder: (context, song, _) {
              if (song == null) return const SizedBox();

              return StreamBuilder<PlayerState>(
                stream: _player.playerStateStream,
                builder: (context, snapshot) {
                  final playing = snapshot.data?.playing ?? false;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 8,
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                song["image"],
                                width: 55,
                                height: 55,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    song["title"],
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    song["artist"],
                                    style: const TextStyle(
                                        color: Colors.white70, fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                playing
                                    ? Icons.pause_circle
                                    : Icons.play_circle,
                                color: Colors.white,
                                size: 40,
                              ),
                              onPressed: () {
                                playing ? _player.pause() : _player.play();
                              },
                            )
                          ],
                        ),

                        // -------- POSITION SLIDER --------
                        StreamBuilder<Duration>(
                          stream: _player.positionStream,
                          builder: (context, snapshot) {
                            final position = snapshot.data ?? Duration.zero;
                            final total = _player.duration ?? Duration.zero;

                            return Slider(
                              value: position.inSeconds.toDouble(),
                              max: total.inSeconds.toDouble(),
                              onChanged: (value) {
                                _player.seek(Duration(
                                    seconds: value.toInt()));
                              },
                              activeColor: Colors.blueAccent,
                              inactiveColor: Colors.white24,
                            );
                          },
                        )
                      ],
                    ),
                  );
                },
              );
            },
          )
        ],
      ),
    );
  }
}
