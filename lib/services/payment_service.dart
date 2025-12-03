import 'dart:convert';

import 'package:foodie_padi_apps/models/card_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PaymentService {
  final String baseUrl;
  final String token;
  PaymentService(this.baseUrl, {required this.token});

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<List<CardModel>> getSavedCard() async {
    final token = await _getToken();
    final response = await http.get(Uri.parse('$baseUrl/api/payments/cards'),
        headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((c) => CardModel.fromJson(c)).toList();
    } else {
      throw Exception('Failed to fetch cards');
    }
  }

  Future<void> deleteCard(String cardId) async {
    final token = await _getToken();
    await http.delete(Uri.parse('$baseUrl/api/payments/cards/$cardId'),
        headers: {'Authorization': 'Bearer $token'});
  }

  Future<Map<String, dynamic>?> startPayment({
    required String orderId,
    required String token,
    bool mobileSdk = false,
    String? couponCode,
  }) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/api/payments/start'),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "orderId": orderId,
        "mobileSdk": mobileSdk,
        "couponCode": couponCode ?? "",
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      print('userToken: $token');
      return jsonDecode(response.body);
    } else {
      throw Exception(
        jsonDecode(response.body)["error"] ?? "Payment initiation failed",
      );
    }
  }

  Future<Map<String, dynamic>?> confirmPayment(String reference) async {
    final token = await _getToken();
    final response = await http.get(
        Uri.parse('$baseUrl/api/payments/confirm/$reference'),
        headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final err = jsonDecode(response.body);
      throw Exception(err['error'] ?? 'Payment verification failed');
    }
  }

  Future<Map<String, dynamic>> getOrderStatus(String orderId) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/api/payments/orders/$orderId/verify-payment'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('Order status response: ${response.statusCode}');
    print('Body: ${response.body}');

    final body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {
        'success': true,
        'status': body['payment']?['status'] ?? 'UNKNOWN',
        'confirmed': body['confirmed'] ?? false,
      };
    } else if (response.statusCode == 402) {
      // Still pending, not verified yet
      return {
        'success': false,
        'status': body['details']?['currentStatus'] ?? 'PENDING',
        'message': body['error'] ?? 'Payment not verified yet',
      };
    } else {
      throw Exception(
          'Failed to fetch order status: ${body['error'] ?? 'Unknown error'}');
    }
  }
}
