import 'package:flutter/cupertino.dart';

class SignUpProvider extends ChangeNotifier {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  bool get obscurePassword => _obscurePassword;

  bool get obscureConfirmPassword => _obscureConfirmPassword;

  bool get isLoading => _isLoading;

  Future<bool> signUp({
    required String email,
    required String fullName,
    required String phoneNumber,
    required String password,
  }) async {
    // Simulate a network call
    await Future.delayed(Duration(seconds: 2));

    // Here you would typically send the data to your backend
    // For now, we just return true to indicate success
    return true;
  }

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    notifyListeners();
  }
}
