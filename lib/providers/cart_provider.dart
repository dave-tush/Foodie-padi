import 'package:flutter/material.dart';

import '../models/cart_item.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  List<CartItem> get item => _items;

  final List<CartItem> _item = [
    CartItem(
      id: '1',
      name: 'Ewa Agoyin',
      imageUrl: 'https://example.com/ewa.jpg',
      price: 6.00,
      quantity: 1,
      extras: [
        ExtraItem(name: 'Plantain', price: 0.50),
        ExtraItem(name: 'Meat', price: 2.00),
      ],
    ),
    CartItem(
      id: '2',
      name: 'Chicken and Chip',
      imageUrl: 'https://example.com/chicken_chip.jpg',
      price: 15.00,
      quantity: 1,
    ),
    CartItem(
      id: '3',
      name: 'Pepper Soup',
      imageUrl: 'https://example.com/pepper_soup.jpg',
      price: 8.00,
      quantity: 1,
    ),
  ];

  void addItem(CartItem item) {
    _items.add(item);
    notifyListeners();
  }

  void increaseQuantity(String id) {
    final item = _items.firstWhere((element) => element.id == id);
    item.quantity++;
    notifyListeners();
  }

  void decreaseQuantity(String id) {
    final item = _items.firstWhere((element) => element.id == id);
    if (item.quantity > 1) {
      item.quantity--;
      notifyListeners();
    }
  }

  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  double get totalPrice =>
      _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get deliveryFee => 1.32;

  double get discount => 1.32;

  double get finalTotal => totalPrice + deliveryFee - discount;
}
