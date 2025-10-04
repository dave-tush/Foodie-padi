import 'package:flutter/material.dart';
import 'package:foodie_padi_apps/models/review/review_model.dart';
import 'package:foodie_padi_apps/services/review_services.dart';

enum ReviewFilter {
  all,
  positive,
  negative,
  stars,
}

class ReviewsProvider with ChangeNotifier {
  final ReviewService reviewService;
  ReviewsProvider(this.reviewService);

  List<Reviews> _reviews = [];
  double _averageRating = 0.0;
  int _totalReviews = 0;
  Map<int, int> _ratingCounts = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
  bool _isLoading = false;

  ReviewFilter _activeFilter = ReviewFilter.all;
  int? _starFilter;

  List<Reviews> get reviews => _applyFilter();
  double get averageRating => _averageRating;
  int get totalReviews => _totalReviews;
  Map<int, int> get ratingCounts => _ratingCounts;
  bool get isLoading => _isLoading;
  ReviewFilter get activeFilter => _activeFilter;
  int? get starFilter => _starFilter;

  Future<void> fetchReviews(String productId) async {
    _isLoading = true;
    notifyListeners();

    final data = await reviewService.getReview(productId);
    _reviews = data;
    _totalReviews = _reviews.length;

    if (_reviews.isNotEmpty) {
      _averageRating = _reviews.map((r) => r.rating).reduce((a, b) => a + b) /
          _reviews.length;

      _ratingCounts = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
      for (var r in _reviews) {
        _ratingCounts[r.rating] = (_ratingCounts[r.rating] ?? 0) + 1;
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  void setFilter(ReviewFilter filter, {int? stars}) {
    _activeFilter = filter;
    _starFilter = stars;
    notifyListeners();
  }

  List<Reviews> _applyFilter() {
    switch (_activeFilter) {
      case ReviewFilter.positive:
        return _reviews.where((r) => r.rating >= 4).toList();
      case ReviewFilter.negative:
        return _reviews.where((r) => r.rating <= 2).toList();
      case ReviewFilter.stars:
        return _reviews
            .where((r) => _starFilter != null && r.rating == _starFilter)
            .toList();
      default:
        return _reviews;
    }
  }
}
