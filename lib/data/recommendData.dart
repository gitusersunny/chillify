class RecommendationResponse {
  final bool success;
  final String? message;
  final List<Recommendation> recommendations;
  final double responseTimeMs;

  RecommendationResponse({
    required this.success,
    this.message,
    required this.recommendations,
    required this.responseTimeMs,
  });

  factory RecommendationResponse.fromJson(Map<String, dynamic> json) {
    return RecommendationResponse(
      success: json['success'] as bool,
      message: json['message'] as String?,
      recommendations: (json['recommendations'] as List<dynamic>?)
          ?.map((e) => Recommendation.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      responseTimeMs: (json['response_time_ms'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'recommendations': recommendations.map((e) => e.toJson()).toList(),
      'response_time_ms': responseTimeMs,
    };
  }
}

class Recommendation {
  final String trackName;
  final String artists;

  Recommendation({
    required this.trackName,
    required this.artists,
  });

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    return Recommendation(
      trackName: json['track_name'] as String,
      artists: json['artists'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'track_name': trackName,
      'artists': artists,
    };
  }
}
