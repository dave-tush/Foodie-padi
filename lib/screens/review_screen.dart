import 'package:flutter/material.dart';
import 'package:foodie_padi_apps/core/constants/app_colors.dart';
import 'package:foodie_padi_apps/providers/review_provider.dart';
import 'package:foodie_padi_apps/services/review_services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

// Removed local enum definition and imported the shared one

class ReviewsScreen extends StatelessWidget {
  final String productId;

  const ReviewsScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ReviewsProvider(
          ReviewService(baseUrl: 'https://food-paddi-backend.onrender.com'))
        ..fetchReviews(productId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Reviews"),
          centerTitle: true,
        ),
        body: Consumer<ReviewsProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.reviews.isEmpty) {
              return const Center(child: Text("No reviews found."));
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ⭐ Rating Summary Section
                  Row(
                    children: [
                      Text(
                        provider.averageRating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: List.generate(
                              5,
                              (index) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 20,
                              ),
                            ),
                          ),
                          Text("(${provider.totalReviews} reviews)"),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 📊 Rating Bars
                  Column(
                    children: provider.ratingCounts.entries.map((e) {
                      final percent = provider.totalReviews > 0
                          ? e.value / provider.totalReviews
                          : 0.0;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          children: [
                            Text("${e.key} "),
                            Expanded(
                              child: LinearProgressIndicator(
                                value: percent,
                                backgroundColor: Colors.grey[200],
                                color: AppColors.primaryOrange,
                                minHeight: 12,
                                stopIndicatorRadius: 32,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text("${e.value}"),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // 🧩 Filter Chips
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildFilterButton(
                        context,
                        "All",
                        provider.activeFilter == ReviewFilter.all,
                        () => provider.setFilter(ReviewFilter.all),
                      ),
                      _buildFilterButton(
                        context,
                        "Positive",
                        provider.activeFilter == ReviewFilter.positive,
                        () => provider.setFilter(ReviewFilter.positive),
                      ),
                      _buildFilterButton(
                        context,
                        "Negative",
                        provider.activeFilter == ReviewFilter.negative,
                        () => provider.setFilter(ReviewFilter.negative),
                      ),
                      for (int i = 5; i >= 1; i--)
                        _buildFilterButton(
                          context,
                          "$i★",
                          provider.activeFilter == ReviewFilter.stars &&
                              provider.starFilter == i,
                          () =>
                              provider.setFilter(ReviewFilter.stars, stars: i),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 📝 Reviews List
                  ...provider.reviews.map((review) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundImage: NetworkImage(review
                                      .userAvatar.isNotEmpty
                                  ? review.userAvatar
                                  : "https://ui-avatars.com/api/?name=${review.userName}"),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        review.userName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Row(
                                        children: List.generate(
                                          review.rating,
                                          (index) => const Icon(Icons.star,
                                              color: Colors.amber, size: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    DateFormat('dd/MM/yyyy')
                                        .format(review.createdAt),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    review.comment,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFilterButton(
      BuildContext context, String label, bool selected, VoidCallback onTap) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: Colors.orange.shade300,
      backgroundColor: Colors.grey.shade200,
      labelStyle: TextStyle(
        color: selected ? Colors.white : Colors.black,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
