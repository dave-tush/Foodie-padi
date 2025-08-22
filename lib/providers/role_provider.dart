import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

import '../services/role_service.dart';

class RoleProvider extends ChangeNotifier {
  String? _role;
  String? _token;

  String? get role => _role;
  String? get token => _token;

  void setToken(String token) {
    _token = token;
    notifyListeners();
  }

  Future<bool> setRole(String role) async {
    if (_token == null) throw Exception('Token is not set');
    final success = await RoleService.setUserRole(_token!, role);
    if (success) {
      _role = role;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_role', role);
      notifyListeners();
      return true;
    } else {
      print('Failed to set role in RoleProvider');
      return false;
    }
  }

  Future<void> loadRoleFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    _role = prefs.getString('user_role');
    notifyListeners();
  }
}
