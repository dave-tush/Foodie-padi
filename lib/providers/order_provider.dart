import 'package:flutter/material.dart';
import 'package:foodie_padi_apps/models/order_model.dart';
import 'package:foodie_padi_apps/services/order_service.dart';

class OrdersProvider extends ChangeNotifier {
  final OrderService orderService;

  OrdersProvider(this.orderService);

  bool isLoading = false;
  String? error;

  List<OrderModel> _allOrders = [];

  List<OrderModel> get currentOrders =>
      _allOrders.where(_isCurrentOrder).toList();

  List<OrderModel> get previousOrders =>
      _allOrders.where(_isPreviousOrder).toList();

  Future<void> fetchOrders() async {
    try {
      isLoading = true;
      notifyListeners();

      _allOrders = await orderService.fetchOrders();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// 🟠 CURRENT
  bool _isCurrentOrder(OrderModel order) {
    return ![
      "DELIVERED",
      "COMPLETED",
    ].contains(order.status);
  }

  /// ✅ PREVIOUS
  bool _isPreviousOrder(OrderModel order) {
    return [
      "DELIVERED",
      "COMPLETED",
    ].contains(order.status);
  }

  /// UI LABEL
  String getReadableStatus(String status) {
    switch (status) {
      case "PAYMENT_CONFIRMED":
        return "Preparing meal";
      case "PREPARING":
        return "Preparing meal";
      case "OUT_FOR_DELIVERY":
        return "Out for delivery";
      case "DELIVERED":
      case "COMPLETED":
        return "Delivered";
      default:
        return status.replaceAll("_", " ");
    }
  }
}
