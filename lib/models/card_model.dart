class CardModel {
  final String id;
  final String last4;
  final String brand;
  final bool isdefault;
  final DateTime createdAt;

  CardModel({
    required this.id,
    required this.last4,
    required this.brand,
    required this.isdefault,
    required this.createdAt,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: json['id'],
      last4: json['last4'],
      brand: json['brand'],
      isdefault: json['isdefault'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
