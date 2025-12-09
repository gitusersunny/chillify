class SpotifySearchResponse {
  final Tracks tracks;

  SpotifySearchResponse({required this.tracks});

  factory SpotifySearchResponse.fromJson(Map<String, dynamic> json) {
    return SpotifySearchResponse(
      tracks: Tracks.fromJson(json['tracks']),
    );
  }

  Map<String, dynamic> toJson() => {
    'tracks': tracks.toJson(),
  };
}
class Tracks {
  final String href;
  final int limit;
  final String? next;
  final int offset;
  final String? previous;
  final int total;
  final List<TrackItem> items;

  Tracks({
    required this.href,
    required this.limit,
    this.next,
    required this.offset,
    this.previous,
    required this.total,
    required this.items,
  });

  factory Tracks.fromJson(Map<String, dynamic> json) {
    return Tracks(
      href: json['href'],
      limit: json['limit'],
      next: json['next'],
      offset: json['offset'],
      previous: json['previous'],
      total: json['total'],
      items: (json['items'] as List)
          .map((i) => TrackItem.fromJson(i))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'href': href,
    'limit': limit,
    'next': next,
    'offset': offset,
    'previous': previous,
    'total': total,
    'items': items.map((e) => e.toJson()).toList(),
  };
}
class TrackItem {
  final int discNumber;
  final int durationMs;
  final bool explicit;
  final ExternalIds externalIds;
  final ExternalUrls externalUrls;
  final String href;
  final String id;
  final bool isLocal;
  final bool isPlayable;
  final String name;
  final int popularity;
  final String? previewUrl;
  final int trackNumber;
  final String type;
  final String uri;

  TrackItem({
    required this.discNumber,
    required this.durationMs,
    required this.explicit,
    required this.externalIds,
    required this.externalUrls,
    required this.href,
    required this.id,
    required this.isLocal,
    required this.isPlayable,
    required this.name,
    required this.popularity,
    this.previewUrl,
    required this.trackNumber,
    required this.type,
    required this.uri,
  });

  factory TrackItem.fromJson(Map<String, dynamic> json) {
    return TrackItem(
      discNumber: json['disc_number'],
      durationMs: json['duration_ms'],
      explicit: json['explicit'],
      externalIds: ExternalIds.fromJson(json['external_ids']),
      externalUrls: ExternalUrls.fromJson(json['external_urls']),
      href: json['href'],
      id: json['id'],
      isLocal: json['is_local'],
      isPlayable: json['is_playable'],
      name: json['name'],
      popularity: json['popularity'],
      previewUrl: json['preview_url'],
      trackNumber: json['track_number'],
      type: json['type'],
      uri: json['uri'],
    );
  }

  Map<String, dynamic> toJson() => {
    'disc_number': discNumber,
    'duration_ms': durationMs,
    'explicit': explicit,
    'external_ids': externalIds.toJson(),
    'external_urls': externalUrls.toJson(),
    'href': href,
    'id': id,
    'is_local': isLocal,
    'is_playable': isPlayable,
    'name': name,
    'popularity': popularity,
    'preview_url': previewUrl,
    'track_number': trackNumber,
    'type': type,
    'uri': uri,
  };
}
class ExternalIds {
  final String isrc;

  ExternalIds({required this.isrc});

  factory ExternalIds.fromJson(Map<String, dynamic> json) {
    return ExternalIds(isrc: json['isrc']);
  }

  Map<String, dynamic> toJson() => {
    'isrc': isrc,
  };
}
class ExternalUrls {
  final String spotify;

  ExternalUrls({required this.spotify});

  factory ExternalUrls.fromJson(Map<String, dynamic> json) {
    return ExternalUrls(spotify: json['spotify']);
  }

  Map<String, dynamic> toJson() => {
    'spotify': spotify,
  };
}
