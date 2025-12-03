// Fixed and improved CartServices\import 'dart:convert';
import 'dart:convert';

import 'package:foodie_padi_apps/models/cart/cart_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CartServices {
  final String baseUrl;
  CartServices(this.baseUrl);

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  // Fetch user cart
  Future<CartModel> getCart() async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/api/cart'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
    );

    print('GET CART: ${response.statusCode}');
    print(response.body);

    if (response.statusCode == 201) {
      final decoded = jsonDecode(response.body);
      return CartModel.fromJson(decoded['data']);
    } else {
      throw Exception('Failed to load cart: ${response.body}');
    }
  }

  // Add item to cart
  Future<CartModel> addToCart(
      String productId, int quantity, List<String> selectedOptions) async {
    final token = await _getToken();

    final body = {
      'productId': productId,
      'quantity': quantity,
      'options': selectedOptions,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/api/cart/add'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(body),
    );

    print('ADD TO CART: ${response.statusCode}');
    print(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final decoded = jsonDecode(response.body);
      return CartModel.fromJson(decoded['data']);
    } else {
      throw Exception('Failed to add item: ${response.body}');
    }
  }

  // Update cart item
  Future<CartModel> updateCartItem(
      String itemId, int quantity, List<String> selectedOptions) async {
    final token = await _getToken();

    final response = await http.put(
      Uri.parse('$baseUrl/api/cart/items/$itemId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        'quantity': quantity,
        'options': selectedOptions,
      }),
    );

    print('UPDATE ITEM: ${response.statusCode}');
    print(response.body);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return CartModel.fromJson(decoded['data']);
    } else {
      throw Exception('Failed to update cart: ${response.body}');
    }
  }

  // Remove item
  Future<CartModel> removeFromCart(String itemId) async {
    final token = await _getToken();

    final response = await http.delete(
      Uri.parse('$baseUrl/api/cart/items/$itemId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
    );

    print('REMOVE ITEM: ${response.statusCode}');
    print(response.body);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return CartModel.fromJson(decoded['data']);
    } else {
      throw Exception('Remove error: ${response.body}');
    }
  }

  // Clear cart
  Future<String> clearCart() async {
    final token = await _getToken();

    final response = await http.delete(
      Uri.parse('$baseUrl/api/cart'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
    );

    print('CLEAR CART: ${response.statusCode}');

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return decoded['message'] ?? 'Cart cleared';
    } else {
      throw Exception('Failed to clear cart: ${response.body}');
    }
  }

  // Checkout cart
  Future<Map<String, dynamic>> checkoutCart(
      String addressId, String? specialRequest) async {
    final token = await _getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/api/cart/checkout'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(
          {'addressId': addressId, 'specialRequest': specialRequest ?? ''}),
    );

    print('CHECKOUT: ${response.statusCode}');
    print(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final decoded = jsonDecode(response.body);
      return decoded;
    } else {
      throw Exception('Checkout failed: ${response.body}');
    }
  }
}
