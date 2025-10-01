import 'package:foodie_padi_apps/models/product/product_model.dart';
import 'package:foodie_padi_apps/models/product/product_option.dart';
import 'package:foodie_padi_apps/models/vendor/vendor_model.dart';

class CartModel {
  final String? id;
  final VendorModel? vendor;
  final List<CartItem> items;
  final double basePrice;
  final double totalPrice;
  final String? specialRequest;

  CartModel({
    this.id,
    this.vendor,
    this.items = const [],
    this.basePrice = 0.0,
    this.totalPrice = 0.0,
    this.specialRequest,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'],
      vendor:
          json['vendor'] != null ? VendorModel.fromJson(json['vendor']) : null,
      items: json['items'] != null
          ? List<CartItem>.from(
              json['items'].map((e) => CartItem.fromJson(e)).toList())
          : [],
      basePrice: (json['basePrice'] is num)
          ? (json['basePrice'] as num).toDouble()
          : 0.0,
      totalPrice: (json['totalPrice'] is num)
          ? (json['totalPrice'] as num).toDouble()
          : 0.0,
      specialRequest: json['specialRequest'],
    );
  }
}

class CartItem {
  final String id;
  final ProductModel product;
  final List<ProductOption> options;
  final int quantity;
  final double unitPrice;
  final double subTotal;

  CartItem({
    required this.id,
    required this.product,
    this.options = const [],
    this.quantity = 1,
    this.unitPrice = 0.0,
    this.subTotal = 0.0,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] ?? '',
      product: json['product'] != null
          ? ProductModel.fromJson(json['product'])
          : ProductModel(
              id: '',
              name: '',
              price: 0.0,
              images: [],
              averageRating: 0.0,
              reviewCount: 0,
              viewCount: 0,
              popularityScore: 0.0,
            ),
      options: json['options'] != null
          ? List<ProductOption>.from(
              json['options'].map((e) => ProductOption.fromJson(e)).toList())
          : [],
      quantity:
          (json['quantity'] is num) ? (json['quantity'] as num).toInt() : 1,
      unitPrice: (json['unitPrice'] is num)
          ? (json['unitPrice'] as num).toDouble()
          : 0.0,
      subTotal: (json['subTotal'] is num)
          ? (json['subTotal'] as num).toDouble()
          : 0.0,
    );
  }
}
