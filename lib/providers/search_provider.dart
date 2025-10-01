import 'package:flutter/material.dart';
import 'package:foodie_padi_apps/models/product/product_model.dart';
import 'package:foodie_padi_apps/models/product/product_suggestion.dart';
import 'package:foodie_padi_apps/services/product_services.dart';

class SearchProvider extends ChangeNotifier {
  final ProductServices productServices;

  SearchProvider(this.productServices);

  List<ProductModel> _searchResult = [];
  List<ProductSuggestion> _suggestions = [];
  Map<String, dynamic>? _pagination;
  bool _isLoading = false;

  List<ProductModel> get searchResults => _searchResult;
  List<ProductSuggestion> get suggestions => _suggestions;
  Map<String, dynamic>? get pagination => _pagination;
  bool get isLoading => _isLoading;

  void clearSuggestion() {
    _suggestions = [];
    notifyListeners();
  }

  Future<void> search(String query, {int page = 1, int limit = 10}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final data =
          await productServices.searchProduct(query, page: page, limit: limit);
      _searchResult = data['results'];
      _pagination = data['pagination']; // ✅ fixed key
    } catch (e) {
      _searchResult = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchSuggestions(String query) async {
    if (query.isEmpty) {
      _suggestions = [];
      notifyListeners();
      return;
    }
    try {
      _suggestions = await productServices.getSuggestion(query);
    } catch (e) {
      _suggestions = [];
    }
    notifyListeners();
  }
}
