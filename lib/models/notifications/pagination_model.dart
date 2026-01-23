class PaginationModel {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  PaginationModel(
      {required this.total,
      required this.page,
      required this.limit,
      required this.totalPages});

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
        total: json['total'],
        page: json['page'],
        limit: json['limit'],
        totalPages: json['totalPages']);
  }
}
