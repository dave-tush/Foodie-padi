class ProductOption {
  final String id;
  final String productId;
  final String name;
  final double price;

  ProductOption({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
  });

  factory ProductOption.fromJson(Map<String, dynamic> json) {
    return ProductOption(
        id: json['id'],
        productId: json['productId'],
        name: json['name'],
        price: (json['price'] as num).toDouble());
  }
}
