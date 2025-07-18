import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class AuthServices {
  final String _baseUrl = 'https://food-paddi-node-swlw.onrender.com';

  Future<Map<String, dynamic>> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
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
    print('SignUp Response: ${response.statusCode} - ${response.body}');
    final data = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return data;
    } else if (response.statusCode == 400) {
      throw Exception('Bad request: ${data['message']}');
      print(data['message']);
    } else if (response.statusCode == 409) {
      throw Exception('Conflict: ${data['message']}');
      print(data['message']);
    } else if (response.statusCode == 500) {
      throw Exception('Server error: ${data['message']}');
      print(data['message']);
    } else {
      throw Exception('error: ${data['message']}');
      print(data['message']);
    }
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
