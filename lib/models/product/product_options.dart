class ProductOptions {
  final String id;
  final String productId;
  final String name;
  final double price;

  ProductOptions({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
  });
  factory ProductOptions.fromJson(Map<String, dynamic> json) {
    return ProductOptions(
      id: json['id'] ?? '',
      productId: json['productId'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] is num) ? (json['price'] as num).toDouble() : 0.0,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'name': name,
      'price': price,
    };
  }
}
