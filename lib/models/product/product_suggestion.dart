class ProductSuggestion {
  final String id;
  final String name;
  final String category;
  final DateTime createdAt;

  ProductSuggestion({
    required this.id,
    required this.name,
    required this.category,
    required this.createdAt,
  });

  factory ProductSuggestion.fromJson(Map<String, dynamic> json) {
    return ProductSuggestion(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? 'Uncategorized',
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}
