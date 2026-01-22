import 'package:flutter/material.dart';
import 'package:foodie_padi_apps/models/customer_order_stats.dart';
import 'package:foodie_padi_apps/models/user_model.dart';
import 'package:foodie_padi_apps/services/customer_order_stats_services.dart';
import 'package:foodie_padi_apps/services/profile_services.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileServices profileServices;
  final CustomerOrderStatsService customerOrderStatsService;
  ProfileProvider(this.profileServices, this.customerOrderStatsService);
  CustomerOrderStatsModel? orderStat;

  bool isOrderStatsLoading = false;
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;

  Future<void> fetchCustomerOrderStats() async {
    try {
      isOrderStatsLoading = true;
      notifyListeners();

      orderStat = await customerOrderStatsService.fetchCustomerOrderStats();
      print(orderStat);
    } catch (e) {
      debugPrint('Order stats error: $e');
    } finally {
      isOrderStatsLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchProfile() async {
    _isLoading = true;
    notifyListeners();
    try {
      _user = await profileServices.getProfile();
    } catch (e) {
      print('Error fetching profile: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile(Map<String, dynamic> body) async {
    _isLoading = true;
    notifyListeners();
    try {
      _user = await profileServices.updateProfile(body);
    } catch (e) {
      print('Error updating profile: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
