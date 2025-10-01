import 'package:foodie_padi_apps/models/product/product_option.dart';

class ProductModel {
  final String id;
  final String name;
  final String? description;
  final double price;
  final String? availability;
  final bool? available;
  final String? category;
  final String? orderOpenAt;
  final String? orderCloseAt;
  final List<String> images;
  final List<String>? video;
  final String? vendorId;
  final List<ProductOption>? options;
  final double averageRating;
  final int reviewCount;
  final int viewCount;
  final double popularityScore;

  ProductModel({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.availability,
    this.available,
    this.category,
    this.orderOpenAt,
    this.orderCloseAt,
    this.options,
    required this.images,
    this.video,
    this.vendorId,
    required this.averageRating,
    required this.reviewCount,
    required this.viewCount,
    required this.popularityScore,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      price: (json['price'] is num) ? (json['price'] as num).toDouble() : 0.0,
      availability: json['availability'],
      available: json['available'],
      category: json['category'],
      orderOpenAt: json['order_openAt'],
      orderCloseAt: json['order_closeAt'],
      images: List<String>.from(json['images'] ?? []),
      video: json['video'] != null ? List<String>.from(json['video']) : null,
      vendorId: json['vendorId'],
      averageRating: (json['averageRating'] is num)
          ? (json['averageRating'] as num).toDouble()
          : 0.0,
      reviewCount: (json['reviewCount'] is num)
          ? (json['reviewCount'] as num).toInt()
          : 0,
      viewCount:
          (json['totalViews'] is num) ? (json['totalViews'] as num).toInt() : 0,
      popularityScore: (json['popularityScore'] is num)
          ? (json['popularityScore'] as num).toDouble()
          : 0.0,
      options: json['options'] != null
          ? List<ProductOption>.from(
              (json['options'] as List).map((x) => ProductOption.fromJson(x)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'availability': availability,
      'available': available,
      'category': category,
      'order_openAt': orderOpenAt,
      'order_closeAt': orderCloseAt,
      'images': images,
      'video': video,
      'vendorId': vendorId,
      'averageRating': averageRating,
      'reviewCount': reviewCount,
      'totalViews': viewCount,
      'popularityScore': popularityScore,
      'options': options,
    };
  }
}
