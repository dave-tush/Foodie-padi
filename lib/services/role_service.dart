import 'dart:convert';

import 'package:http/http.dart' as http;

class RoleService {
  static String baseUrl = "https://food-paddi-backend.onrender.com";
  static Future<bool> setUserRole(String token, String role) async {
    final url = Uri.parse('$baseUrl/api/auth/select-role');
    try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'role': role}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Decoded role update response: $data');
      return data['role'] == role;
    } else {
      print('Failed to set user role: ${response.statusCode} ${response.body}');
      return false;
    }
    } catch (e){
      print('Error setting user role: $e');
      return false;
    }
  }
}
