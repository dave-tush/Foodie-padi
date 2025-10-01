import 'package:foodie_padi_apps/models/product/product_model.dart';

class PaginatedProduct {
  final List<ProductModel> products;
  final int page;
  final int totalPages;

  PaginatedProduct({
    required this.products,
    required this.page,
    required this.totalPages,
  });
}
