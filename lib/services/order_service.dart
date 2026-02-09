import 'dart:convert';
import 'package:foodie_padi_apps/models/order_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OrderService {
  final String baseUrl;

  OrderService({required this.baseUrl});

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<List<OrderModel>> fetchOrders() async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/api/order'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      final List<dynamic> ordersJson =
          decoded['data']['orders'] as List<dynamic>;

      return ordersJson
          .map(
            (e) => OrderModel.fromJson(e as Map<String, dynamic>),
          )
          .toList();
    } else {
      throw Exception(
        'Failed to fetch orders: ${response.statusCode}',
      );
    }
  }
}
