import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodie_padi_apps/services/auth_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  String? _accessToken;
  String? _refreshToken;

  User? get user => _user;

  String? get accessToken => _accessToken;

  String? get refreshToken => _refreshToken;

  String? get role => _user?.role;

  bool get isVendor => _user?.role == "VENDOR";

  bool get isCustomer => _user?.role == "CUSTOMER";

  Future<void> loadUsersFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('id');
    final name = prefs.getString('name');

    if (id != null && name != null) {
      _user = User(id: id, name: name, token: '', preferences: []);
      notifyListeners();
    }
  }

  Future<void> saveUsersToLocal(
      User user, String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', jsonEncode(user.toJson()));
    await prefs.setString('access_token', accessToken);
    await prefs.setString('refresh_token', refreshToken);

    _user = user;
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    print("✅ User saved: ${user.name}, token: $accessToken");
    notifyListeners();
  }

  Future<void> loadUsersFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user_data');
    final token = prefs.getString('access_token');
    final refresh = prefs.getString('refresh_token');

    print("🧩 Raw userJson: $userJson");
    print("🧩 Raw token: $token");

    if (userJson == null || token == null) {
      print("🚫 No user or token found in local storage.");
      return; // ✅ Prevent from calling .fromJson with null
    }

    try {
      _user = User.fromJson(jsonDecode(userJson), token);
      _accessToken = token;
      _refreshToken = refresh;
      print("🔄 Loaded user: ${_user?.name}, token: $_accessToken");
    } catch (e) {
      print("❌ Error loading user from local: $e");
    }

    notifyListeners();
  }

  Future<void> clearUsersFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data');
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    _user = null;
    _accessToken = null;
    _refreshToken = null;
    notifyListeners();
  }

  Future<void> updateRole(String role) async {
    if (_user == null) return;
    _user = User(
        id: _user!.id,
        name: _user!.name,
        email: _user!.email,
        role: role.toUpperCase(),
        username: _user!.username,
        phoneNumber: _user!.phoneNumber,
        token: _user!.token,
        avatarUrl: _user!.avatarUrl,
        preferences: _user!.preferences,
        bio: _user!.bio,
        address: _user!.address,
        brandName: _user!.brandName,
        brandLogo: _user!.brandLogo);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', jsonEncode(_user!.toJson()));
    notifyListeners();
  }

  Future<bool> refreshAccessToken() async {
    if (_refreshToken == null || _refreshToken!.isEmpty) {
      print("🚫 No refresh token available.");
      return false;
    }
    try {
      final newToken = await AuthServices.refreshToken(_refreshToken!);
      _accessToken = newToken['access_token'];
      _refreshToken =
          newToken['refresh_token']; // Assuming refresh token remains the same
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', _accessToken!);
      await prefs.setString('refresh_token', _refreshToken!);
      notifyListeners();
      print("🔄 Access token refreshed successfully.");
      return true;
    } catch (e) {
      print("❌ Error refreshing access token: $e");
      return false;
    }
  }
}
