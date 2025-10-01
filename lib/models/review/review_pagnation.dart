class ReviewPagnation {
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  ReviewPagnation({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });
  factory ReviewPagnation.fromJson(Map<String, dynamic> json) {
    return ReviewPagnation(
      page: json['page'],
      limit: json['limit'],
      total: json['total'],
      totalPages: json['totalPages'],
    );
  }
  factory ReviewPagnation.empty() {
    return ReviewPagnation(
      totalPages: 1,
      page: 1,
      limit: 20,
      total: 100,
    );
  }
}
