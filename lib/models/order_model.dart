class OrderModel {
  final String id;
  final String status;
  final double totalPrice;
  final DateTime createdAt;
  final String vendorName;

  OrderModel(
      {required this.id,
      required this.status,
      required this.totalPrice,
      required this.createdAt,
      required this.vendorName});

      factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      status: json['status'],
      totalPrice: (json['totalPrice'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
      vendorName: json['vendor']['name'],
    );
  }
}


