import 'package:flutter/material.dart';
import 'package:foodie_padi_apps/models/cart/cart_model.dart';
import 'package:foodie_padi_apps/services/cart_services.dart';

class CartProvider extends ChangeNotifier {
  final CartServices _cartServices;
  CartModel? _cart;
  bool _isLoading = false;

  CartProvider(this._cartServices);

  CartModel? get cart => _cart;
  bool get isLoading => _isLoading;
  int get totalItems =>
      _cart?.items.fold(0, (sum, item) => sum! + item.quantity) ?? 0;
  double get totalPrice => _cart?.totalPrice ?? 0.0;

  //fetch cart from backend
  Future<void> fetchCart() async {
    _setLoading(true);
    try {
      _cart = await _cartServices.getCart();
      notifyListeners();
    } catch (e) {
      debugPrint('Fetch cart error: $e');
    }
    _setLoading(false);
  }

  //add product to cart
  Future<void> addToCart(
      String productId, int quantity, List<String> selectedOptions) async {
    _setLoading(true);
    try {
      _cart =
          await _cartServices.addToCart(productId, quantity, selectedOptions);
      notifyListeners();
    } catch (e) {
      debugPrint('Add to cart error: $e');
    }
    _setLoading(false);
  }

  //update existing cart item
  Future<void> updateCartItem(
      String itemId, int quantity, List<String> selectedOptions) async {
    _setLoading(true);
    try {
      _cart =
          await _cartServices.updateCartItem(itemId, quantity, selectedOptions);
      notifyListeners();
    } catch (e) {
      debugPrint("Update cart item error: $e");
    }
    _setLoading(false);
  }

  /// Remove an item from the cart
  Future<void> removeCartItem(String itemId) async {
    _setLoading(true);
    try {
      _cart = await _cartServices.removeFromCart(itemId);
      notifyListeners();
    } catch (e) {
      debugPrint("Remove cart item error: $e");
    }
    _setLoading(false);
  }

  /// Clear entire cart
  Future<void> clearCart() async {
    _setLoading(true);
    try {
      await _cartServices.clearCart();
      _cart = null;
      notifyListeners();
    } catch (e) {
      debugPrint("Clear cart error: $e");
    }
    _setLoading(false);
  }

  /// Checkout
  Future<Map<String, dynamic>?> checkout(
      {String? addressId, String? specialRequest}) async {
    _setLoading(true);
    try {
      final result =
          await _cartServices.checkoutCart(addressId ?? '', specialRequest);
      // Reset cart after checkout
      _cart = null;
      notifyListeners();
      return result;
    } catch (e) {
      debugPrint("Checkout error: $e");
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Helper: set loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
