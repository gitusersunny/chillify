class MusicSearchRequest {
  final String track;
  final String artist;
  final String type;
  final List<String> sources;

  MusicSearchRequest({
    required this.track,
    required this.artist,
    required this.type,
    required this.sources,
  });

  Map<String, dynamic> toJson() => {
    'track': track,
    'artist': artist,
    'type': type,
    'sources': sources,
  };
}