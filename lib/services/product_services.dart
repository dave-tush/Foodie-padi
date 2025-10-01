import 'dart:convert';

import 'package:foodie_padi_apps/models/product/paginated_product.dart';
import 'package:foodie_padi_apps/models/product/product_suggestion.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/api_constants.dart';
import '../models/product/product_model.dart';
import '../providers/user_provider.dart';

class ProductServices {
  final String baseUrl;
  ProductServices(this.baseUrl);

  // final productServices = ProductServices(ApiConstants.baseUrl);
  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken') ?? '';
  }

  Future<Map<String, dynamic>> searchProduct(String query,
      {int page = 1, int limit = 10}) async {
    final response = await http.get(Uri.parse(
        '$baseUrl/api/product/p/search?q=$query&page=$page&limit=$limit'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final results = data['data']?['results'] as List;
      return {
        "results": results.map((e) => ProductModel.fromJson(e)).toList(),
        "pagination": data['pagination'],
        "fromCache": data['fromCache'],
      };
    } else {
      throw Exception('Failed to load search message');
    }
  }

  Future<List<ProductSuggestion>> getSuggestion(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/product/p/suggestions?q=$query'),
    );
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final results = body['data']?['results'] as List;
      return results.map((e) => ProductSuggestion.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch suggestions');
    }
  }

  Future<PaginatedProduct> fetchProducts({int page = 1, int limit = 20}) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/api/product?page=$page&limit=$limit'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final products = (data['data'] as List)
          .map((item) => ProductModel.fromJson(item))
          .toList();

      // ✅ handle pagination safely
      final pagination = data['pagination'] ?? {};
      final currentPage = pagination['page'] ?? page;
      final totalPages = pagination['totalPages'] ?? 1;

      return PaginatedProduct(
        products: products,
        page: currentPage,
        totalPages: totalPages,
      );
    } else {
      throw Exception('Failed to fetch products: ${response.statusCode}');
    }
  }

  Future<ProductModel> fetchProductById(String id) async {
    final respones = await http.get(Uri.parse('$baseUrl/api/product/$id'));
    if (respones.statusCode == 200) {
      // final data = json.decode(respones.body);
      final decoded = json.decode(respones.body);
      final data = decoded['data'];
      return ProductModel.fromJson(data);
    } else if (respones.statusCode == 404) {
      throw Exception('Product not found');
    } else if (respones.statusCode == 500) {
      throw Exception('Server error');
    } else {
      throw Exception('Failed to load product');
    }
  }
}
