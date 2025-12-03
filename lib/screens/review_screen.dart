import 'package:flutter/material.dart';
import 'package:foodie_padi_apps/core/constants/app_colors.dart';
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
        ReviewService(baseUrl: 'https://food-paddi-backend.onrender.com'),
      )..fetchReviews(productId),
      child: Scaffold(
        appBar: AppBar(title: const Text("Reviews")),
        body: Consumer<ReviewsProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildRatingSummary(provider),
                const SizedBox(height: 24),
                _buildFilterButtons(context, provider),
                const SizedBox(height: 20),
                if (provider.reviews.isEmpty)
                  const Center(
                    child: Text(
                      "No reviews found.",
                      style: TextStyle(fontSize: 15),
                    ),
                  )
                else
                  ...provider.reviews.map(_buildReviewTile).toList(),
              ],
            );
          },
        ),
      ),
    );
  }

  // ✅ SAFE version — no Expanded, only Flexible and SizedBox
  Widget _buildRatingSummary(ReviewsProvider provider) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      (index) => Icon(
                        index < provider.averageRating.round()
                            ? Icons.star
                            : Icons.star_border,
                        color: AppColors.primaryOrange,
                        size: 20,
                      ),
                    ),
                  ),
                  Text(
                    "(${provider.reviews.length} reviews)",
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: Column(
            children: provider.ratingCounts.entries.map((e) {
              final percent = provider.reviews.isNotEmpty
                  ? e.value / provider.reviews.length
                  : 0.0;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    Text("${e.key} "),
                    Expanded(
                      child: SizedBox(
                        height: 10,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: percent,
                            backgroundColor: Colors.grey[200],
                            color: AppColors.primaryOrange,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Text("${e.value}"),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterButtons(BuildContext context, ReviewsProvider provider) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
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
            () => provider.setFilter(ReviewFilter.stars, stars: i),
          ),
      ],
    );
  }

  Widget _buildReviewTile(review) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 6),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          review.userAvatar.isNotEmpty
              ? review.userAvatar
              : "https://ui-avatars.com/api/?name=${review.userName}",
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            review.userName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Row(
            children: List.generate(
              review.rating,
              (index) => Icon(
                Icons.star,
                color: AppColors.primaryOrange,
                size: 16,
              ),
            ),
          ),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Text(
          review.comment,
          style: const TextStyle(fontSize: 13),
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
      selectedColor: AppColors.primaryOrange,
      backgroundColor: Colors.grey.shade200,
      labelStyle: TextStyle(
        color: selected ? Colors.white : Colors.black,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
