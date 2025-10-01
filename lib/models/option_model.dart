class OptionModel {
  final String id;
  final String productId;
  final String name;
  final double price;

  OptionModel({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
  });

  factory OptionModel.fromJson(Map<String, dynamic> json) {
    return OptionModel(
      id: json['id'] ?? '',
      productId: json['productId'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
    );
  }
}
