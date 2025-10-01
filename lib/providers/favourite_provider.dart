import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:foodie_padi_apps/models/product/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavouriteProvider extends ChangeNotifier {
  final List<ProductModel> _favouriteItems = [];
  List<ProductModel> get favouriteItems => _favouriteItems;

  bool isFavourite(String id) =>
      _favouriteItems.any((productModel) => productModel.id == id);

  Future<void> loadFavourites() async {
    final prefs = await SharedPreferences.getInstance();
    final favList = prefs.getStringList('favouriteItems') ?? [];
    _favouriteItems.clear();
    _favouriteItems.addAll(
        favList.map((e) => ProductModel.fromJson(jsonDecode(e))).toList());
    notifyListeners();
  }

  void toggleFavourite(ProductModel product) async {
    if (isFavourite(product.id)) {
      _favouriteItems.removeWhere((m) => m.id == product.id);
    } else {
      _favouriteItems.add(product);
    }
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'favouriteItems',
      _favouriteItems.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }

  void toggleFavouriteByParams(
      {required String id,
      required String imgPath,
      required String title,
      required double rating,
      required double price}) {
    final product = ProductModel(
      id: id,
      name: title,
      images: [imgPath],
      averageRating: rating,
      price: price,
      reviewCount: 1,
      viewCount: 2,
      popularityScore: 3,
    );
    toggleFavourite(product);
  }
}
