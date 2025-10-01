import 'dart:convert';

import 'package:foodie_padi_apps/models/cart/cart_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CartServices {
  final String baseUrl;
  CartServices(this.baseUrl);

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // get current cart
  Future<CartModel> getCart() async {
    final token = await _getToken();
    final response = await http.get(Uri.parse('$baseUrl/api/cart'),
        headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      return CartModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load cart');
    }
  }

  // add item to cart
  Future<CartModel> addToCart(
      String productId, int quantity, List<String> selectedOptions) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/api/cart/add'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        'productId': productId,
        'quantity': quantity,
        'options': selectedOptions
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return CartModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add item to cart');
    }
  }

  // update cart item
  Future<CartModel> updateCartItem(
      String itemId, int quantity, List<String> selectedOptions) async {
    final token = await _getToken();
    final response = await http.put(
        Uri.parse('$baseUrl/api/cart/items/$itemId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'quantity': quantity, 'options': selectedOptions}));
    if (response.statusCode == 200) {
      return CartModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update cart item');
    }
  }

  // remove item from cart
  Future<CartModel> removeFromCart(String itemId) async {
    final token = await _getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/api/cart/items/$itemId'),
      headers: {'Authorization': 'Bearer $token'},
      body: jsonEncode({'itemId': itemId}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is Map && data.containsKey('message')) {
        print('Message: ${data['message']}');
        return CartModel(items: []);
      }
      return CartModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to remove item from cart');
    }
  }

  // checkout cart
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
          {'addressId': addressId, 'specialRequest': specialRequest}),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to checkout cart');
    }
  }

  //clear entire cart
  Future<String> clearCart() async {
    final token = await _getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/api/cart'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['message'];
    } else {
      throw Exception('Failed to clear cart');
    }
  }
}
