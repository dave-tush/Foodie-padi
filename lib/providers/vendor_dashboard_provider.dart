import 'package:flutter/material.dart';
import 'package:foodie_padi_apps/models/vendor/vendor_dashboard_model.dart';
import 'package:foodie_padi_apps/services/vendor_dashboard_services.dart';

class VendorDashboardProvider with ChangeNotifier {
  VendorDashboard? _dashboard;
  bool _isLoading = false;
  String? _error;

  VendorDashboard? get dashboard => _dashboard;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadDashboard(String token, String vendorId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _dashboard = await VendorDashboardService.getVendorDashboard(
        token: token,
        vendorId: vendorId,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
