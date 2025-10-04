import 'dart:convert';

import 'package:foodie_padi_apps/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileServices {
  final String baseUrl;
  ProfileServices(this.baseUrl);

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<User> getProfile() async {
    final token = await _getToken();
    final response =
        await http.get(Uri.parse("$baseUrl/api/auth/profile"), headers: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User.fromJson(data['user'], token ?? '');
    } else {
      throw Exception('Failed to load profile');
    }
  }

  Future<User> updateProfile(Map<String, dynamic> body) async {
    final token = await _getToken();
    final response = await http.patch(
      Uri.parse('$baseUrl/api/auth/profile'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User.fromJson(data['user'], token ?? '');
    } else {
      throw Exception('Failed to update profile');
    }
  }
}
