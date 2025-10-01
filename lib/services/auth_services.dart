import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices {
  final String _baseUrl = 'https://food-paddi-backend.onrender.com';

  Future<Map<String, dynamic>> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    print('Sending sign up request to $_baseUrl');
    final response = await http.post(
      Uri.parse('$_baseUrl/api/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
      }),
    );
    final decodedBody = jsonDecode(response.body);
    print(
        'SignUp Response: ${response.statusCode} - ${decodedBody['accessToken']}');
    print('response body: ${response.body}');
    final data = jsonDecode(response.body);
    print("📦 Parsed data: $data");
    if (response.statusCode == 200 || response.statusCode == 201) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', data['accessToken'] ?? '');
      await prefs.setString('refreshToken', data['refreshToken'] ?? '');
      return data;
    } else if (response.statusCode == 400) {
      print(data['message']);
      throw Exception('Bad request: ${data['message']}');
    } else if (response.statusCode == 409) {
      print(data['message']);
      throw Exception('Conflict: ${data['message']}');
    } else if (response.statusCode == 500) {
      print(data['message']);
      throw Exception('Server error: ${data['message']}');
    } else {
      print(data['message']);
      throw Exception('error: ${data['message']}');
    }
  }

  static Future<Map<String, String>> refreshToken(String refreshToken) async {
    print('Refreshing token with refreshToken: $refreshToken');
    // This method is a placeholder for token refresh logic.
    // Implement your token refresh logic here if needed.
    // For now, it returns a dummy map.
    return Future.value({
      'accessToken': 'newAccessToken',
      'refreshToken': 'newRefreshToken',
    });
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );
    print('SignUp Response: ${response.statusCode} - ${response.body}');
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return data;
    } else if (response.statusCode == 400) {
      throw Exception('Bad request: ${data['message']}');
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: ${data['message']}');
    } else if (response.statusCode == 500) {
      throw Exception('Server error: ${data['message']}');
    } else {
      throw Exception('Failed to log in');
    }
  }
}
