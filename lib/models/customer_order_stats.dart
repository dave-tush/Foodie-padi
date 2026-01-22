class CustomerOrderStatsModel {
  final int totalOrders;
  final int completedOrders;
  final int inProgressOrders;
  final int awaitingPaymentOrders;
  final double totalSpent;
  final List<Last7DaysOrder> last7DaysOrders;

  CustomerOrderStatsModel({
    required this.totalOrders,
    required this.completedOrders,
    required this.inProgressOrders,
    required this.awaitingPaymentOrders,
    required this.totalSpent,
    required this.last7DaysOrders,
  });

  factory CustomerOrderStatsModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;

    return CustomerOrderStatsModel(
      totalOrders: data['totalOrders'],
      completedOrders: data['completedOrders'],
      inProgressOrders: data['inProgressOrders'],
      awaitingPaymentOrders: data['awaitingPaymentOrders'],
      totalSpent: (data['totalSpent'] ?? 0).toDouble(),
      last7DaysOrders: (data['last7DaysOrders'] as List)
          .map((e) => Last7DaysOrder.fromJson(e))
          .toList(),
    );
  }
}

class Last7DaysOrder {
  final String date;
  final int orders;

  Last7DaysOrder({
    required this.date,
    required this.orders,
  });

  factory Last7DaysOrder.fromJson(Map<String, dynamic> json) {
    return Last7DaysOrder(
      date: json['date'],
      orders: json['orders'],
    );
  }
}
