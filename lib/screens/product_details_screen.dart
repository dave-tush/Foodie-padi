// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:foodie_padi_apps/core/constants/app_colors.dart';
import 'package:foodie_padi_apps/models/product/product_model.dart';
import 'package:foodie_padi_apps/providers/cart_provider.dart';
import 'package:foodie_padi_apps/providers/product_provider.dart';
import 'package:foodie_padi_apps/screens/homescreen/cart_screen.dart';
import 'package:foodie_padi_apps/screens/review_screen.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final PageController _pageController = PageController();
  ProductModel? productModel;
  bool isLoading = true;

  // 👇 Add this to track selected options
  List<bool> selectedOptions = [];

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  int quantity = 1; // 👈 add in your State class

  double _calculateTotalPrice() {
    if (productModel == null) return 0.0;

    double total = productModel!.price;
    for (int i = 0; i < (productModel!.options?.length ?? 0); i++) {
      if (selectedOptions[i]) {
        total += productModel!.options![i].price;
      }
    }
    return total * quantity;
  }

  Future<void> _loadProduct() async {
    final service = context.read<ProductProvider>().productServices;
    try {
      final fetched = await service.fetchProductById(widget.productId);
      setState(() {
        productModel = fetched;
        // Initialize selection states based on number of options
        selectedOptions =
            List.generate(fetched.options?.length ?? 0, (_) => false);
      });
    } catch (e) {
      debugPrint("Error loading product: $e");
    } finally {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = productModel;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isLoading ? "Loading..." : (product?.name ?? "Product Details"),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : product == null
              ? const Center(child: Text("Product not found"))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 120.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// ---------------- Product Images ----------------
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: SizedBox(
                              height: 400,
                              width: double.infinity,
                              child: PageView.builder(
                                controller: _pageController,
                                itemCount: product.images.length,
                                itemBuilder: (context, index) {
                                  return Image.network(
                                    product.images[index],
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Icon(
                                      Icons.image,
                                      size: 100,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        if (product.images.isNotEmpty)
                          Center(
                            child: SmoothPageIndicator(
                              controller: _pageController,
                              count: product.images.length,
                              effect: ExpandingDotsEffect(
                                dotHeight: 12,
                                dotWidth: 12,
                                expansionFactor: 3,
                                activeDotColor: AppColors.secondaryYellow,
                                dotColor: AppColors.orangeBackground,
                              ),
                            ),
                          ),

                        const SizedBox(height: 20),

                        /// ---------------- Product Name + Price ----------------
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          product.available == true
                              ? "In Stock"
                              : "Out of Stock",
                          style: TextStyle(
                            fontSize: 14,
                            color: product.available == true
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          product.price != null
                              ? "₦${product.price}"
                              : "Price unavailable",
                          style: TextStyle(
                            fontSize: 20,
                            color: AppColors.secondaryYellow,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 20),
                            SizedBox(width: 4),
                            Text(
                              product.averageRating != null
                                  ? product.averageRating.toStringAsFixed(1)
                                  : "0.0",
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(width: 8),
                            Text(
                              product.reviewCount != null
                                  ? "(${product.reviewCount} reviews)"
                                  : "(0 reviews)",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                            Spacer(),
                            RichText(
                              text: TextSpan(
                                  text: 'See all reviews',
                                  style: TextStyle(
                                      color: AppColors.secondaryYellow,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.underline),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => ReviewsScreen(
                                                    productId: product.id,
                                                  )));
                                    }),
                            ),
                          ],
                        ),
                        Text(
                          product.description != null
                              ? "${product.description}"
                              : "description unavailable",
                          style: TextStyle(
                            fontSize: 14,
                            //color: AppColors.secondaryYellow,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(product.category != null
                            ? "Category: ${product.category}"
                            : "Category unavailable"),

                        const SizedBox(height: 20),

                        /// ---------------- Options ----------------
                        Text(
                          "Available Options",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),

                        product.options != null && product.options!.isNotEmpty
                            ? SizedBox(
                                height: 200,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: product.options!.length,
                                  itemBuilder: (context, index) {
                                    final option = product.options![index];

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Row(
                                        children: [
                                          // Left: Option Name
                                          Expanded(
                                            child: Text(
                                              option.name,
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          ),

                                          // Right: Price + Checkbox
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                option.price != null
                                                    ? "₦${option.price}"
                                                    : "Price unavailable",
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ),
                                              const SizedBox(width: 10),
                                              Checkbox(
                                                checkColor:
                                                    AppColors.background,
                                                activeColor:
                                                    AppColors.secondaryYellow,
                                                value: (index <
                                                        selectedOptions.length)
                                                    ? selectedOptions[index]
                                                    : false,
                                                onChanged: (value) {
                                                  setState(() {
                                                    if (index <
                                                        selectedOptions
                                                            .length) {
                                                      selectedOptions[index] =
                                                          value ?? false;
                                                    }
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              )
                            : const Text("No options available"),

                        const SizedBox(height: 20),

                        /// ---------------- Add to Cart ----------------

                        /// ---------------- Buy Now ----------------
                      ],
                    ),
                  ),
                ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Consumer<CartProvider>(
          builder: (context, cartProvider, child) {
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                children: [
                  /// Quantity selector
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () {
                      if (quantity > 1) {
                        setState(() => quantity--);
                      }
                    },
                  ),
                  Text('$quantity', style: const TextStyle(fontSize: 18)),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () {
                      setState(() => quantity++);
                    },
                  ),

                  const SizedBox(width: 12),

                  /// Add to Cart button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        final selectedIds = <String>[];
                        for (int i = 0; i < selectedOptions.length; i++) {
                          if (selectedOptions[i]) {
                            selectedIds.add(productModel!.options![i].id);
                          }
                        }

                        cartProvider.addToCart(
                            productModel!.id, quantity, selectedIds);

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CartScreen()));
                      },
                      icon: const Icon(
                        Icons.shopping_bag,
                        size: 32,
                        color: AppColors.white,
                      ),
                      label: Text(
                        "Add to Cart \n (₦${_calculateTotalPrice().toStringAsFixed(0)})",
                        style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.white,
                            fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryOrange,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
