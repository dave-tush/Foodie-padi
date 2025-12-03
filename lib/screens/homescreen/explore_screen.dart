import 'package:flutter/material.dart';
import 'package:foodie_padi_apps/core/constants/app_assets.dart';
import 'package:foodie_padi_apps/models/product/product_model.dart';
import 'package:foodie_padi_apps/providers/product_provider.dart';
import 'package:foodie_padi_apps/widgets/build_meal_card.dart';
import 'package:provider/provider.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  int _selectedCategoryIndex = 0;
  String _searchQuery = "";

  final List<String> categories = [
    'All',
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snacks'
  ];

  @override
  void initState() {
    super.initState();
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    productProvider.loadProducts(reset: true);

    _scrollController.addListener(() {
      final provider = Provider.of<ProductProvider>(context, listen: false);
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !provider.isLoading &&
          !provider.isLastPage) {
        provider.loadProducts();
      }
    });
  }

  Future<void> _refreshProducts() async {
    await Provider.of<ProductProvider>(context, listen: false)
        .loadProducts(reset: true);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshProducts,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              // 🔎 Search bar (not pinned, scrolls away)
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Search meals or vendors...",
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                setState(() {
                                  _controller.clear();
                                  _searchQuery = "";
                                });
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() => _searchQuery = value.toLowerCase());
                    },
                  ),
                ),
              ),

              // 🍽 Categories (pinned)
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  minHeight: 50,
                  maxHeight: 50,
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            label: Text(categories[index]),
                            selected: _selectedCategoryIndex == index,
                            onSelected: (_) {
                              setState(() {
                                _selectedCategoryIndex = index;
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              // 🥘 Meals Grid
              Consumer<ProductProvider>(
                builder: (context, productProvider, child) {
                  final products = productProvider.products;

                  if (productProvider.isLoading && products.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    );
                  }

                  if (products.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text('No meals found',
                              style: TextStyle(color: Colors.grey)),
                        ),
                      ),
                    );
                  }

                  // ✅ Filter by category + search
                  List<ProductModel> filteredProducts = products;
                  if (_selectedCategoryIndex != 0) {
                    final category = categories[_selectedCategoryIndex];
                    filteredProducts = filteredProducts
                        .where((p) => p.category == category.toUpperCase())
                        .toList();
                  }
                  if (_searchQuery.isNotEmpty) {
                    filteredProducts = filteredProducts
                        .where((p) =>
                            p.name.toLowerCase().contains(_searchQuery) ||
                            (p.vendorId?.toLowerCase().contains(_searchQuery) ??
                                false))
                        .toList();
                  }

                  return SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index == filteredProducts.length) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        final product = filteredProducts[index];
                        return buildMealCard(
                          context: context,
                          id: product.id,
                          imgPath: product.images.isNotEmpty
                              ? product.images.first
                              : AppAssets.bg,
                          title: product.name,
                          rating: product.averageRating.toDouble(),
                          price: product.price,
                        );
                      },
                      childCount: filteredProducts.length +
                          (productProvider.isLoading ? 1 : 0),
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.75,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 👇 Helper delegate to pin category bar
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
