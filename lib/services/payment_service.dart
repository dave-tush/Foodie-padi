import 'dart:convert';

import 'package:foodie_padi_apps/models/card_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PaymentService {
  final String baseUrl;
  PaymentService(this.baseUrl);

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

  Future<Map<String, dynamic>> startPayment({
    required String id,
    required double amount,
    String? currency,
  }) async {
    final token = await _getToken();
    final response = await http.post(Uri.parse('$baseUrl/api/payments/start'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(
            {'cardId': id, 'amount': amount, 'currency': currency ?? 'NGN'}));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Payment failed: ${response.body}');
    }
  }
}
