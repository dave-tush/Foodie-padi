
class Vendor {
  final String name;
  final String location;
  final int currentOrders;
  final int specialOrders;
  final List<Sale> sales;
  final double averageRating;
  final int totalReviews;

  Vendor({
    required this.name,
    required this.location,
    required this.currentOrders,
    required this.specialOrders,
    required this.sales,
    required this.averageRating,
    required this.totalReviews,
  });

  double get totalSales => sales.fold(0, (sum, item) => sum + item.amount);
}

class Sale {
  final String time;
  final double amount;

  Sale({required this.time, required this.amount});

}