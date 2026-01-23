import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:foodie_padi_apps/models/notifications/notifications_response.dart';

class NotificationServices {
  final String baseUrl;
  NotificationServices(this.baseUrl);

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  // ================= FETCH =================
  Future<NotificationsResponse> fetchResponse() async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/api/order/notifications'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    final decoded = json.decode(response.body);

    if (response.statusCode == 200 && decoded['success'] == true) {
      return NotificationsResponse.fromJson(decoded['data']);
    } else {
      throw Exception(decoded['message']);
    }
  }

  // ================= MARK ALL =================
  Future<bool> markAllRead() async {
    final token = await _getToken();

    final response = await http.patch(
      Uri.parse('$baseUrl/api/order/notifications/read-all'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    final decoded = json.decode(response.body);

    if (response.statusCode == 200 && decoded['success'] == true) {
      return true;
    } else {
      throw Exception(decoded['message']);
    }
  }

  // ================= MARK ONE =================
  Future<bool> markAsRead(String id) async {
    final token = await _getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/api/order/notifications/$id/read'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    final decoded = json.decode(response.body);

    if (response.statusCode == 200 && decoded['success'] == true) {
      return true;
    } else {
      throw Exception(decoded['message']);
    }
  }
}
