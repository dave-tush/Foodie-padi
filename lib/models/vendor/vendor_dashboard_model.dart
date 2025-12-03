class VendorDashboard {
  final int currentOrders;
  final int specialOrders;
  final double totalSales;
  final double averageRating;
  final int totalReviews;
  final List<double> salesTimeline;

  VendorDashboard({
    required this.currentOrders,
    required this.specialOrders,
    required this.totalSales,
    required this.averageRating,
    required this.totalReviews,
    required this.salesTimeline,
  });

  factory VendorDashboard.fromJson({
    required Map<String, dynamic> stats,
    required Map<String, dynamic> report,
    required Map<String, dynamic> reviews,
  }) {
    return VendorDashboard(
      currentOrders: stats['pendingOrders'] ?? 0,
      specialOrders: 0, // optional extension later
      totalSales: (report['summary']?['totalRevenue'] ?? 0).toDouble(),
      averageRating: (reviews['averageRating'] ?? 0).toDouble(),
      totalReviews: reviews['totalReviews'] ?? 0,
      salesTimeline: _parseSalesTimeline(report['dailyOrders']),
    );
  }

  static List<double> _parseSalesTimeline(dynamic dailyOrders) {
    if (dailyOrders == null) return [];
    return (dailyOrders as List)
        .map((e) => (e['revenue'] ?? 0).toDouble())
        .toList()
        .cast<double>();
  }
}
