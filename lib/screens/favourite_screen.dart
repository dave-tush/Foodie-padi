import 'package:flutter/material.dart';
import 'package:foodie_padi_apps/core/constants/app_assets.dart';
import 'package:foodie_padi_apps/models/product/product_model.dart';
import 'package:foodie_padi_apps/providers/product_provider.dart';
import 'package:foodie_padi_apps/widgets/build_meal_card.dart';
import 'package:provider/provider.dart';
import '../providers/favourite_provider.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favProvider = Provider.of<FavouriteProvider>(context);
    final ProductProvider productProvider =
        Provider.of<ProductProvider>(context);
    final products = productProvider.products;
    final favProducts = products
        .where((product) => favProvider.isFavourite(product.id))
        .toList();

    return favProvider.favouriteItems.isEmpty
        ? const Center(child: Text("No favourites yet"))
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
            child: ListView.builder(
              itemCount: favProvider.favouriteItems.length,
              itemBuilder: (context, index) {
                final products = favProducts[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: buildMealCard(
                      id: products.id,
                      imgPath: products.images.isNotEmpty
                          ? products.images.first
                          : AppAssets.bg,
                      title: products.name,
                      rating: products.averageRating,
                      price: products.price,
                      context: context),
                );
              },
            ),
          );
  }
}
