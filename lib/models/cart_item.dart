class CartItem {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final List<ExtraItem> extras;
  int quantity;
  CartItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.extras = const [],
    this.quantity = 1,
  });
  double get totalPrice {
    final extrasTotal = extras.fold(0.0, (sum, e) => sum + e.price);
    return (price + extrasTotal) * quantity;
  }
}

class ExtraItem {
  final String name;
  final double price;

  ExtraItem({required this.name, required this.price});
}
