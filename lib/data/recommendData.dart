class RecommendationResponse {
  final String song;
  final RecommendationData recommendations;

  RecommendationResponse({
    required this.song,
    required this.recommendations,
  });

  factory RecommendationResponse.fromJson(Map<String, dynamic> json) {
    return RecommendationResponse(
      song: json["song"],
      recommendations: RecommendationData.fromJson(json["recommendations"]),
    );
  }
}

class RecommendationData {
  final bool success;
  final List<RecommendationItem> recommendations;

  RecommendationData({
    required this.success,
    required this.recommendations,
  });

  factory RecommendationData.fromJson(Map<String, dynamic> json) {
    return RecommendationData(
      success: json["success"],
      recommendations: (json["recommendations"] as List)
          .map((item) => RecommendationItem.fromJson(item))
          .toList(),
    );
  }
}

class RecommendationItem {
  final String trackName;
  final String artists;

  RecommendationItem({
    required this.trackName,
    required this.artists,
  });

  factory RecommendationItem.fromJson(Map<String, dynamic> json) {
    return RecommendationItem(
      trackName: json["track_name"],
      artists: json["artists"],
    );
  }
}
