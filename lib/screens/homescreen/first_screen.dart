// lib/screens/first_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodie_padi_apps/core/constants/app_assets.dart';
import 'package:foodie_padi_apps/core/constants/app_colors.dart';
import 'package:foodie_padi_apps/models/product/product_model.dart';
import 'package:foodie_padi_apps/providers/product_provider.dart';
import 'package:foodie_padi_apps/providers/profile_provider.dart';
import 'package:foodie_padi_apps/screens/product_details_screen.dart';
import 'package:foodie_padi_apps/widgets/build_meal_card.dart';
import 'package:foodie_padi_apps/widgets/promo_carousel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Constants for the first screen
class _FirstScreenConstants {
  static const String categoryKey = 'selectedCategoryIndex';
  static const String firstLunchKey = 'first_lunch';
  static const String hasLaunchedBeforeKey = 'hasLaunchedBefore';
  static const double scrollThreshold = 200.0;
  static const int gridCrossAxisCount = 2;
  static const double gridChildAspectRatio = 0.75;
  static const Duration searchDebounceDelay = Duration(milliseconds: 300);

  static const List<String> categories = [
    'All',
    'BREAKFAST',
    'LUNCH',
    'DINNER',
    'SNACKS',
    'DRINKS',
  ];
}

/// Main home screen displaying products with search and category filters
class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _searchDebounceTimer;

  String _searchQuery = "";
  int _selectedCategoryIndex = 0;
  String _greeting = "Good Morning";
  List<ProductModel>? _cachedFilteredProducts;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileProvider =
          Provider.of<ProfileProvider>(context, listen: false);
      if (profileProvider.user == null) {
        profileProvider.fetchProfile();
      } else {
        _setGreeting();
      }
    });
    _initializeScreen();
  }

  Future<void> _initializeScreen() async {
    _setGreeting();
    await _loadSavedCategory();
    _checkFirstLaunch();

    // Initialize product loading and scroll listener
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final provider = Provider.of<ProductProvider>(context, listen: false);
        provider.loadProducts(reset: true);
        _setupScrollListener(provider);
      });
    }
  }

  void _setupScrollListener(ProductProvider provider) {
    _scrollController.addListener(() {
      if (!mounted) return;

      final position = _scrollController.position;
      final isNearBottom = position.pixels >=
          position.maxScrollExtent - _FirstScreenConstants.scrollThreshold;

      if (isNearBottom && !provider.isLoading && !provider.isLastPage) {
        provider.loadProducts();
      }
    });
  }

  @override
  void dispose() {
    _searchDebounceTimer?.cancel();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _setGreeting() {
    final hour = DateTime.now().hour;
    setState(() {
      if (hour < 12) {
        _greeting = "Good Morning";
      } else if (hour < 18) {
        _greeting = "Good Afternoon";
      } else {
        _greeting = "Good Evening";
      }
    });
  }

  Future<void> _loadSavedCategory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (mounted) {
        setState(() {
          _selectedCategoryIndex =
              prefs.getInt(_FirstScreenConstants.categoryKey) ?? 0;
        });
      }
    } catch (e) {
      debugPrint('Error loading saved category: $e');
    }
  }

  Future<void> _saveSelectedCategory(int index) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_FirstScreenConstants.categoryKey, index);
    } catch (e) {
      debugPrint('Error saving category: $e');
    }
  }

  Future<void> _refreshProducts() async {
    try {
      await Provider.of<ProductProvider>(context, listen: false)
          .loadProducts(reset: true);
      _clearCache();
    } catch (e) {
      debugPrint('Error refreshing products: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to refresh products')),
        );
      }
    }
  }

  Future<void> _checkFirstLaunch() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final firstLunch =
          prefs.getBool(_FirstScreenConstants.firstLunchKey) ?? true;
      final hasLaunchedBefore =
          prefs.getBool(_FirstScreenConstants.hasLaunchedBeforeKey) ?? false;

      if (!hasLaunchedBefore) {
        await prefs.setBool(_FirstScreenConstants.hasLaunchedBeforeKey, true);
      }

      if (firstLunch && mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showWelcomeDialog();
        });
      }
    } catch (e) {
      debugPrint('Error checking first launch: $e');
    }
  }

  Future<void> _showWelcomeDialog() async {
    if (!mounted) return;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Welcome to Foodie Padi!'),
        content: const Text('Enjoy your first lunch with us!'),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool(_FirstScreenConstants.firstLunchKey, false);
              } catch (e) {
                debugPrint('Error saving first lunch flag: $e');
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _onSearchChanged(String value) {
    _searchDebounceTimer?.cancel();
    _searchDebounceTimer = Timer(_FirstScreenConstants.searchDebounceDelay, () {
      if (mounted) {
        setState(() {
          _searchQuery = value.trim().toLowerCase();
          _clearCache();
        });
      }
    });
  }

  void _clearSearch() {
    _searchDebounceTimer?.cancel();
    setState(() {
      _searchController.clear();
      _searchQuery = "";
      _clearCache();
    });
  }

  void _clearCache() {
    _cachedFilteredProducts = null;
  }

  List<ProductModel> _filterProducts(List<ProductModel> products) {
    // Return cached result if available
    if (_cachedFilteredProducts != null && _searchQuery.isEmpty) {
      return _cachedFilteredProducts!;
    }

    var filtered = List<ProductModel>.from(products);

    // Filter by category
    final selectedCategory =
        _FirstScreenConstants.categories[_selectedCategoryIndex];
    if (selectedCategory != 'All') {
      filtered = filtered
          .where(
              (product) => product.category?.toUpperCase() == selectedCategory)
          .toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((product) =>
              product.name.toLowerCase().contains(_searchQuery) ||
              (product.description?.toLowerCase().contains(_searchQuery) ??
                  false) ||
              (product.vendorId?.toLowerCase().contains(_searchQuery) ?? false))
          .toList();
    }

    // Cache result if no search query
    if (_searchQuery.isEmpty) {
      _cachedFilteredProducts = filtered;
    }

    return filtered;
  }

  void _onCategorySelected(int index) async {
    setState(() {
      _selectedCategoryIndex = index;
      _clearCache();
    });
    await _saveSelectedCategory(index);
  }

  void _navigateToProductDetails(String productId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsScreen(productId: productId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context).user;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshProducts,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              _buildHeaderSection(
                  profileProvider?.username, profileProvider?.address),
              _buildCategorySection(),
              _buildProductsSection(),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the header section with greeting, search bar, and promo carousel
  Widget _buildHeaderSection(String? userName, List? address) {
    return SliverToBoxAdapter(
      child: Padding(
        padding:
            EdgeInsets.only(left: 16.w, right: 16.w, top: 36.h, bottom: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: AppColors.grey.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.menu),
                  ),
                ),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DELIVER TO',
                      style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.primaryOrange,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      address?.first.street ?? 'No address',
                      style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(height: 16.h),
            Text(
              userName != null
                  ? "$_greeting,\n$userName"
                  : "$_greeting,\nloading...",
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              "What are you craving?",
              style: TextStyle(fontSize: 14.sp, color: Colors.grey),
            ),
            SizedBox(height: 16.h),
            _buildSearchBar(),
            SizedBox(height: 20.h),
            const PromoCarousel(),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  /// Builds the search bar widget
  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      onChanged: _onSearchChanged,
      decoration: InputDecoration(
        hintText: 'Search meals or vendors...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _searchQuery.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: _clearSearch,
                tooltip: 'Clear search',
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }

  /// Builds the category filter section
  Widget _buildCategorySection() {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: SizedBox(
          height: 40.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _FirstScreenConstants.categories.length,
            itemBuilder: (context, index) {
              final isSelected = _selectedCategoryIndex == index;
              return Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: ChoiceChip(
                  label: Text(_FirstScreenConstants.categories[index]),
                  selected: isSelected,
                  onSelected: (_) => _onCategorySelected(index),
                  selectedColor:
                      Theme.of(context).primaryColor.withOpacity(0.2),
                  checkmarkColor: Theme.of(context).primaryColor,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  /// Builds the products grid section
  Widget _buildProductsSection() {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        final products = _filterProducts(productProvider.products);

        if (productProvider.isLoading && products.isEmpty) {
          return _buildLoadingIndicator();
        }

        if (products.isEmpty) {
          return _buildEmptyState();
        }

        return SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index == products.length && productProvider.isLoading) {
                  return _buildLoadingMoreIndicator();
                }

                final product = products[index];
                return _buildProductCard(product);
              },
              childCount: products.length + (productProvider.isLoading ? 1 : 0),
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _FirstScreenConstants.gridCrossAxisCount,
              mainAxisSpacing: 10.h,
              crossAxisSpacing: 10.w,
              childAspectRatio: _FirstScreenConstants.gridChildAspectRatio,
            ),
          ),
        );
      },
    );
  }

  /// Builds a product card widget
  Widget _buildProductCard(ProductModel product) {
    return InkWell(
      onTap: () => _navigateToProductDetails(product.id),
      borderRadius: BorderRadius.circular(12.r),
      child: buildMealCard(
        context: context,
        id: product.id,
        imgPath:
            product.images.isNotEmpty ? product.images.first : AppAssets.bg,
        title: product.name,
        rating: product.averageRating,
        price: product.price,
      ),
    );
  }

  /// Builds the initial loading indicator
  Widget _buildLoadingIndicator() {
    return SliverToBoxAdapter(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(20.r),
          child: const CircularProgressIndicator(),
        ),
      ),
    );
  }

  /// Builds the loading more indicator for pagination
  Widget _buildLoadingMoreIndicator() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: CircularProgressIndicator(),
      ),
    );
  }

  /// Builds the empty state widget
  Widget _buildEmptyState() {
    return SliverToBoxAdapter(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(20.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.restaurant_menu,
                size: 64.sp,
                color: Colors.grey,
              ),
              SizedBox(height: 16.h),
              Text(
                'No meals found',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (_searchQuery.isNotEmpty) ...[
                SizedBox(height: 8.h),
                Text(
                  'Try adjusting your search or filter',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
