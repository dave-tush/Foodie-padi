class RatingBreakdown {
  final int stars;
  final int count;
  final String label;

  RatingBreakdown(
      {required this.stars, required this.count, required this.label});

  factory RatingBreakdown.fromJson(Map<String, dynamic> json) {
    return RatingBreakdown(
      stars: json['stars'],
      count: json['count'],
      label: json['label'],
    );
  }
}
