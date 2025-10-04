import 'dart:convert';

import 'package:foodie_padi_apps/models/review/review_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ReviewService {
  final String baseUrl;
  ReviewService({required this.baseUrl});

  Future<String?> _getToken() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString('accessToken');
  }

  Future<List<Reviews>> getReview(String productId) async {
    try {
      final url = Uri.parse('$baseUrl/api/review/$productId/reviews');
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer ${await _getToken()}',
        'Content-Type': 'application/json',
      });
      print('Fetching reviews from: $url');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List reviews = data['reviews'] ?? [];
        return reviews.map((r) => Reviews.fromJson(r)).toList();
      } else {
        print('Response body: ${response.body}');
        throw Exception('Failed to load reviews');
      }
    } catch (e) {
      print("Error fetching reviews: $e");
      return [];
    }
  }

  Future<List<Review>> getReviews(String productId) async {
    // Replace with Firebase/REST API call
    await Future.delayed(Duration(seconds: 1));
    return [
      Review(
        id: '1',
        userName: 'John Doe',
        userAvatar: 'https://randomuser.me/api/portraits/men/32.jpg',
        date: '29/03/2024',
        rating: 5,
        comment: 'Delicious ewa agoyin! Loved the soft ponmo...',
      ),
      Review(
        id: '2',
        userName: 'David',
        userAvatar: 'https://randomuser.me/api/portraits/men/12.jpg',
        date: '10/04/2024',
        rating: 5,
        comment: 'Absolutely delicious! The bread was soft...',
      ),
    ];
  }
}
