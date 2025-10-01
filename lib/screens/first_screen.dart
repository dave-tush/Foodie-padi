import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodie_padi_apps/core/constants/app_assets.dart';
import 'package:foodie_padi_apps/models/product/product_model.dart';
import 'package:foodie_padi_apps/providers/search_provider.dart';
import 'package:foodie_padi_apps/providers/user_provider.dart';
import 'package:foodie_padi_apps/screens/product_details_screen.dart';
import 'package:foodie_padi_apps/widgets/build_meal_card.dart';
import 'package:foodie_padi_apps/widgets/promo_carousel.dart';
import 'package:foodie_padi_apps/widgets/search.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/product_provider.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  String greeting = "Good Morning";
  bool _isLoading = true;
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  final List<String> categories = [
    'All',
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snacks'
  ];
  int _selectedCategoryIndex = 0; // default is "All"
  String _searchQuery = "";
  @override
  void initState() {
    super.initState();
    _setGreeting();
    _loadSavedCategory();
    _checkFirstLunch();
    Future.microtask(() {
      final provider = Provider.of<ProductProvider>(context, listen: false);
      provider.loadProducts(reset: true);
      _scrollController.addListener(() {
        if (_scrollController.position.pixels >=
                _scrollController.position.maxScrollExtent - 200 &&
            !_isLoadingMore &&
            !provider.isLastPage) {
          _loadMoreProducts();
        }
      });
    });
  }

  Future<void> _loadMoreProducts() async {
    setState(() {
      _isLoadingMore = true;
    });
    await Provider.of<ProductProvider>(context, listen: false).loadProducts();
    setState(() {
      _isLoadingMore = false;
    });
  }

  void _setGreeting() {
    if (DateTime.now().hour < 12) {
      greeting = "Good Morning";
    } else if (DateTime.now().hour < 18) {
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
    // final user = Provider.of<UserProvider>(context, listen: false).user;

    if (!hasLaunchedBefore) {
      await prefs.setBool('hasLaunchedBefore', true);
    }

    if (firstLunch) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Welcome to Foodie Padi!'),
          content: const Text('Enjoy your first lunch with us!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                prefs.setBool('first_lunch', false);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
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
                        "$greeting, \n${user?.name}",
                        style: TextStyle(
                            fontSize: 20.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        "What are you craving?",
                        style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                      ),
                      SizedBox(height: 20.h),
                      // Replace this inside FirstScreen where you currently have `SearchScreen()`
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => SearchScreen()),
                          );
                        },
                        child: TextField(
                          enabled: false, // disable direct typing here
                          decoration: InputDecoration(
                            hintText: 'Search dishes, vendors',
                            prefixIcon: Icon(Icons.search),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide.none,
                            ),
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
                            return Padding(
                              padding: EdgeInsets.only(right: 12.w),
                              child: ChoiceChip(
                                label: Text(categories[index]),
                                selected: _selectedCategoryIndex == index,
                                selectedColor: Colors.green.shade100,
                                onSelected: (_) {
                                  setState(() {
                                    _selectedCategoryIndex = index;
                                  });
                                  _saveSelectedCategory(index);
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
                    final products = productProvider.products;

                    // Initial loading
                    if (productProvider.isLoading && products.isEmpty) {
                      return SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.r),
                            child: const CircularProgressIndicator(),
                          ),
                        ),
                      );
                    }

                    if (products.isEmpty) {
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

                    return SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          // 🔑 If this is the last item and we are still loading → show spinner
                          if (index == products.length) {
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.all(12.r),
                                child: const CircularProgressIndicator(),
                              ),
                            );
                          }

                          // 🔑 Trigger load more when we scroll to the last product
                          if (index == products.length - 1 &&
                              !productProvider.isLoading &&
                              !productProvider.isLastPage) {
                            productProvider.loadProducts();
                          }

                          final product = products[index];
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ProductDetailsScreen(
                                      productId: product.id),
                                ),
                              );
                            },
                            child: buildMealCard(
                              context: context,
                              id: product.id,
                              imgPath: product.images.isNotEmpty
                                  ? product.images.first
                                  : AppAssets.bg,
                              title: product.name,
                              rating: product.averageRating.toDouble(),
                              price: product.price,
                            ),
                          );
                        },
                        // 👇 Add +1 if still loading next page
                        childCount: products.length +
                            (productProvider.isLoading ? 1 : 0),
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
    ;
  }
}
