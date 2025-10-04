import 'package:flutter/material.dart';
import 'package:foodie_padi_apps/providers/review_provider.dart';
import 'package:foodie_padi_apps/services/review_services.dart';
import 'package:provider/provider.dart';

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
        appBar: AppBar(title: const Text("Reviews")),
        body: Consumer<ReviewsProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rating Summary
                  Row(
                    children: [
                      Text(
                        provider.averageRating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 40,
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
                              (index) => const Icon(Icons.star,
                                  color: Colors.amber, size: 20),
                            ),
                          ),
                          Text("(${provider.reviews.length} reviews)"),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Rating bars
                  Column(
                    children: provider.ratingCounts.entries.map((e) {
                      final percent = provider.reviews.isNotEmpty
                          ? e.value / provider.reviews.length
                          : 0.0;
                      return Row(
                        children: [
                          Text("${e.key} "),
                          Expanded(
                            child: LinearProgressIndicator(
                              value: percent,
                              backgroundColor: Colors.grey[200],
                              color: Colors.amber,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text("${e.value}"),
                        ],
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // 🔹 Filter Buttons Row
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildFilterButton(
                          context,
                          "All",
                          provider.activeFilter == ReviewFilter.all,
                          () => provider.setFilter(ReviewFilter.all)),
                      _buildFilterButton(
                          context,
                          "Positive",
                          provider.activeFilter == ReviewFilter.positive,
                          () => provider.setFilter(ReviewFilter.positive)),
                      _buildFilterButton(
                          context,
                          "Negative",
                          provider.activeFilter == ReviewFilter.negative,
                          () => provider.setFilter(ReviewFilter.negative)),
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

                  // Reviews list
                  if (provider.reviews.isEmpty)
                    const Center(child: Text("No reviews found.")),
                  ...provider.reviews.map((review) => ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(review.userAvatar),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(review.userName),
                            Row(
                              children: List.generate(
                                review.rating,
                                (index) => const Icon(Icons.star,
                                    color: Colors.amber, size: 16),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(review.comment,
                                style: const TextStyle(fontSize: 12)),
                            const SizedBox(height: 5),
                            Text(review.comment),
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
      selectedColor: Colors.orange.shade200,
      backgroundColor: Colors.grey.shade200,
    );
  }
}
