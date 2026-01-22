 import 'dart:convert';
import 'package:foodie_padi_apps/models/customer_order_stats.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class CustomerOrderStatsService {
  final String baseUrl;

  CustomerOrderStatsService(this.baseUrl);

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<CustomerOrderStatsModel> fetchCustomerOrderStats() async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/api/order/customer/stats'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return CustomerOrderStatsModel.fromJson(decoded);
    } else {
      throw Exception(
        'Failed to load customer order stats: ${response.statusCode}',
      );
    }
  }
}
