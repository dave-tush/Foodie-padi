import 'package:flutter/material.dart';

class MenuProvider with ChangeNotifier {
  final String title;
  final String imageUrl;
  final double basePrice;

  MenuProvider({
    required this.title,
    required this.imageUrl,
    required this.basePrice,
  });

  bool _addPonmo = false;
  bool _addEjaKika = false;
  String? _meatOption;
  int _quantity = 1;

  bool get addPonmo => _addPonmo;
  bool get addEjaKika => _addEjaKika;
  String? get meatOption => _meatOption;
  int get quantity => _quantity;

  void togglePonmo(bool? value) {
    _addPonmo = value ?? false;
    notifyListeners();
  }

  void toggleEjaKika(bool? value) {
    _addEjaKika = value ?? false;
    notifyListeners();
  }

  void setMeatOption(String option) {
    _meatOption = option;
    notifyListeners();
  }

  void incrementQty() {
    _quantity++;
    notifyListeners();
  }

  void decrementQty() {
    if (_quantity > 1) {
      _quantity--;
      notifyListeners();
    }
  }

  double get totalPrice {
    double total = basePrice;

    if (_addPonmo) total += 0.5;
    if (_addEjaKika) total += 1.0;
    if (_meatOption == 'Extra Beef') total += 2.0;
    if (_meatOption == 'Double Chicken') total += 3.5;

    return total * _quantity;
  }
}
