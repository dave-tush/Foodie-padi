import 'package:flutter/cupertino.dart';
import 'package:foodie_padi_apps/services/product_services.dart';

import '../models/product/product_model.dart';

class ProductProvider extends ChangeNotifier {
  ProductServices productServices;
  ProductProvider(this.productServices);
  List<ProductModel> _products = [];
  bool _isLoading = false;
  bool _isLastPage = false;
  int _currentPage = 1;
  int _totalPages = 1;

  List<ProductModel> get products => _products;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoading && _currentPage > 1;
  bool get isLastPage => _isLastPage;

  Future<void> loadProducts({bool reset = false}) async {
    if (_isLoading || _isLastPage) return;
    _isLoading = true;
    notifyListeners();
    if (reset) {
      _currentPage = 1;
      _isLastPage = false;
      _products = [];
    }
    try {
      final results =
          await productServices.fetchProducts(page: _currentPage, limit: 20);
      _products.addAll(results.products);
      _totalPages = results.totalPages;
      _currentPage++;
      if (_currentPage > _totalPages) {
        _isLastPage = true;
      }
    } catch (e) {
      print('Error loading products: $e');
      if (reset) _products = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
