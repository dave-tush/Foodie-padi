// lib/screens/first_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodie_padi_apps/core/constants/app_assets.dart';
import 'package:foodie_padi_apps/providers/user_provider.dart';
import 'package:foodie_padi_apps/screens/product_details_screen.dart';
import 'package:foodie_padi_apps/widgets/build_meal_card.dart';
import 'package:foodie_padi_apps/widgets/promo_carousel.dart';
import 'package:foodie_padi_apps/widgets/search.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/product_provider.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  String greeting = "Good Morning";
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  final List<String> categories = [
    'All',
    'BREAKFAST',
    'LUNCH',
    'DINNER',
    'SNACKS',
    'DRINKS',
  ];
  int _selectedCategoryIndex = 0; // default is "All"

  @override
  void initState() {
    super.initState();
    _setGreeting();
    _loadSavedCategory();
    _checkFirstLunch();

    // Load initial products and set up scroll listener in a microtask so
    // Provider is available in the widget tree.
    Future.microtask(() {
      final provider = Provider.of<ProductProvider>(context, listen: false);
      provider.loadProducts(reset: true);
      _scrollController.addListener(_onScroll);
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final provider = Provider.of<ProductProvider>(context, listen: false);

    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        !provider.isLastPage) {
      _loadMoreProducts();
    }
  }

  Future<void> _loadMoreProducts() async {
    final provider = Provider.of<ProductProvider>(context, listen: false);

    if (_isLoadingMore || provider.isLastPage) return;

    setState(() => _isLoadingMore = true);

    // productProvider.loadProducts handles internal guard for simultaneous loads
    await provider.loadProducts();

    if (mounted) {
      setState(() => _isLoadingMore = false);
    }
  }

  void _setGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      greeting = "Good Morning";
    } else if (hour < 18) {
      greeting = "Good Afternoon";
    } else {
      greeting = "Good Evening";
    }
  }

  Future<void> _loadSavedCategory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedCategoryIndex = prefs.getInt('selectedCategoryIndex') ?? 0;
    });
  }

  Future<void> _saveSelectedCategory(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedCategoryIndex', index);
  }

  Future<void> _refreshProducts() async {
    await Provider.of<ProductProvider>(context, listen: false)
        .loadProducts(reset: true);
  }

  Future<void> _checkFirstLunch() async {
    final prefs = await SharedPreferences.getInstance();
    final firstLunch = prefs.getBool('first_lunch') ?? true;
    final hasLaunchedBefore = prefs.getBool('hasLaunchedBefore') ?? false;

    if (!hasLaunchedBefore) {
      await prefs.setBool('hasLaunchedBefore', true);
    }

    if (firstLunch && mounted) {
      // showDialog must be called when widget is mounted
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Welcome to Foodie Padi!'),
            content: const Text('Enjoy your first lunch with us!'),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('first_lunch', false);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      });
    }
  }

  // Local filter of products by category (so provider doesn't need to change)
  List<dynamic> _filterProductsByCategory(List products) {
    final selected = categories[_selectedCategoryIndex];
    if (selected == 'All') return products;
    // best-effort: assume product has either `category` or `mealType` or `type`
    return products.where((p) {
      try {
        final pCat = (p?.category ?? p?.mealType ?? p?.type)?.toString();
        if (pCat == null) return false;
        return pCat.toLowerCase() == selected.toLowerCase();
      } catch (_) {
        // if product model doesn't have fields, fallback to true (show all)
        return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: RefreshIndicator(
            onRefresh: _refreshProducts,
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                // Header Section
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h),
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey.shade200,
                            child: const Icon(Icons.menu, color: Colors.black),
                          ),
                          SizedBox(width: 8.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'DELIVER TO',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Oke Afin',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Icon(Icons.keyboard_arrow_down_rounded),
                                ],
                              ),
                            ],
                          ),
                          const Spacer(),
                          Stack(
                            alignment: Alignment.topRight,
                            children: [
                              const CircleAvatar(
                                backgroundColor: Colors.black,
                                child: Icon(Icons.shopping_bag_outlined,
                                    color: Colors.white),
                              ),
                              Positioned(
                                right: 2,
                                top: 2,
                                child: Container(
                                  padding: EdgeInsets.all(4.r),
                                  decoration: const BoxDecoration(
                                    color: Colors.orange,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '2',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10.sp),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 24.h),
                      Text(
                        "$greeting, \n${user?.name ?? 'Guest'}",
                        style: TextStyle(
                            fontSize: 20.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        "What are you craving?",
                        style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                      ),
                      SizedBox(height: 20.h),

                      // Clickable fake search bar (reliable tap)
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => SearchScreen()),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 14.h),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.search, color: Colors.grey),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Text(
                                  'Search dishes, vendors',
                                  style: TextStyle(
                                      fontSize: 14.sp, color: Colors.grey),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: 6.w),
                              Icon(Icons.mic_none, color: Colors.grey)
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // Promo Carousel
                      const PromoCarousel(),
                      SizedBox(height: 20.h),

                      // Category Tabs
                      SizedBox(
                        height: 40.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final selected = _selectedCategoryIndex == index;
                            return Padding(
                              padding: EdgeInsets.only(right: 12.w),
                              child: ChoiceChip(
                                label: Text(categories[index]),
                                selected: selected,
                                selectedColor: Colors.green.shade100,
                                onSelected: (_) async {
                                  setState(() {
                                    _selectedCategoryIndex = index;
                                  });
                                  await _saveSelectedCategory(index);

                                  // Reset provider and reload products from page 1
                                  await Provider.of<ProductProvider>(context,
                                          listen: false)
                                      .loadProducts(reset: true);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 16.h),
                    ],
                  ),
                ),

                // Meals Grid (sliver version)
                Consumer<ProductProvider>(
                  builder: (context, productProvider, child) {
                    final rawProducts = productProvider.products;
                    final filteredProducts =
                        _filterProductsByCategory(rawProducts);

                    // Initial loading
                    if (productProvider.isLoading && rawProducts.isEmpty) {
                      return SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.r),
                            child: const CircularProgressIndicator(),
                          ),
                        ),
                      );
                    }

                    if (filteredProducts.isEmpty) {
                      return SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.r),
                            child: Text(
                              'No meals available',
                              style: TextStyle(
                                  fontSize: 16.sp, color: Colors.grey),
                            ),
                          ),
                        ),
                      );
                    }

                    // include an extra child for loading indicator (when loading more)
                    final childCount = filteredProducts.length +
                        (_isLoadingMore || productProvider.isLoading ? 1 : 0);

                    return SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          // If this is the extra loading tile
                          if (index == filteredProducts.length) {
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.all(12.r),
                                child: const CircularProgressIndicator(),
                              ),
                            );
                          }

                          final product = filteredProducts[index];

                          // navigate to details on tap
                          return InkWell(
                            onTap: () {
                              try {
                                final id = product.id;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ProductDetailsScreen(productId: id),
                                  ),
                                );
                              } catch (_) {
                                // fallback: do nothing if product lacks id
                              }
                            },
                            child: buildMealCard(
                              context: context,
                              id: product.id,
                              imgPath: product.images.isNotEmpty
                                  ? product.images.first
                                  : AppAssets.bg,
                              title: product.name,
                              rating: (product.averageRating ?? 0).toDouble(),
                              price: product.price,
                            ),
                          );
                        },
                        childCount: childCount,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10.h,
                        crossAxisSpacing: 10.w,
                        childAspectRatio: 0.75,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
