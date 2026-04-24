// lib/models/music_search_response.dart
class MusicSearchResponse {
  final List<Track> tracks;

  MusicSearchResponse({required this.tracks});

  factory MusicSearchResponse.fromJson(Map<String, dynamic> json) {
    return MusicSearchResponse(
      tracks: (json['tracks'] as List)
          .map((track) => Track.fromJson(track))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'tracks': tracks.map((track) => track.toJson()).toList(),
  };
}

// lib/models/track.dart
class Track {
  final String source;
  final String status;
  final TrackData data;
  final String type;

  Track({
    required this.source,
    required this.status,
    required this.data,
    required this.type,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      source: json['source'],
      status: json['status'],
      data: TrackData.fromJson(json['data']),
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() => {
    'source': source,
    'status': status,
    'data': data.toJson(),
    'type': type,
  };
}

// lib/models/track_data.dart
class TrackData {
  final String externalId;
  final String? previewUrl;
  final String name;
  final List<String> artistNames;
  final String albumName;
  final String imageUrl;
  final String? isrc;
  final int duration;
  final String url;

  TrackData({
    required this.externalId,
    this.previewUrl,
    required this.name,
    required this.artistNames,
    required this.albumName,
    required this.imageUrl,
    this.isrc,
    required this.duration,
    required this.url,
  });

  factory TrackData.fromJson(Map<String, dynamic> json) {
    return TrackData(
      externalId: json['externalId'],
      previewUrl: json['previewUrl'],
      name: json['name'],
      artistNames: List<String>.from(json['artistNames']),
      albumName: json['albumName'],
      imageUrl: json['imageUrl'],
      isrc: json['isrc'],
      duration: json['duration'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() => {
    'externalId': externalId,
    'previewUrl': previewUrl,
    'name': name,
    'artistNames': artistNames,
    'albumName': albumName,
    'imageUrl': imageUrl,
    'isrc': isrc,
    'duration': duration,
    'url': url,
  };

  // Helper method to get formatted duration
  String getFormattedDuration() {
    final minutes = duration ~/ 60000;
    final seconds = (duration % 60000) ~/ 1000;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}