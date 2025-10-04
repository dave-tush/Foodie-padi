import 'package:foodie_padi_apps/models/review/rating_breakdown.dart';

class ReviewSummaryModel {
  final double averageRating;
  final int totalReviews;
  final List<RatingBreakdown> breakdown;

  ReviewSummaryModel({
    required this.averageRating,
    required this.totalReviews,
    required this.breakdown,
  });

  factory ReviewSummaryModel.fromJson(Map<String, dynamic> json) {
    return ReviewSummaryModel(
      averageRating: (json['averageRating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
      breakdown: (json['breakdown'] as List)
          .map((b) => RatingBreakdown.fromJson(b))
          .toList(),
    );
  }
}
