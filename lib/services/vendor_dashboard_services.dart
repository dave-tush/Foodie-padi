import 'dart:convert';
import 'package:foodie_padi_apps/models/vendor/vendor_dashboard_model.dart';
import 'package:http/http.dart' as http;

class VendorDashboardService {
  static const _baseUrl = 'https://food-paddi-backend.onrender.com/api';

  static Future<VendorDashboard> getVendorDashboard({
    required String token,
    required String vendorId,
  }) async {
    final headers = {'Authorization': 'Bearer $token'};

    final statsRes = await http.get(Uri.parse('$_baseUrl/order/vendor/stats'),
        headers: headers);
    final reportRes = await http.get(Uri.parse('$_baseUrl/order/vendor/report'),
        headers: headers);
    final reviewsRes = await http.get(
        Uri.parse('$_baseUrl/review/vendor/$vendorId/reviews/summary'),
        headers: headers);

    if (statsRes.statusCode == 200 &&
        reportRes.statusCode == 200 &&
        reviewsRes.statusCode == 200) {
      final stats = jsonDecode(statsRes.body);
      final report = jsonDecode(reportRes.body);
      final reviews = jsonDecode(reviewsRes.body);

      return VendorDashboard.fromJson(
        stats: stats,
        report: report,
        reviews: reviews,
      );
    } else {
      throw Exception('Failed to load vendor dashboard data');
    }
  }
}
