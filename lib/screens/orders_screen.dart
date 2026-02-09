import 'package:flutter/material.dart';
import 'package:foodie_padi_apps/core/constants/app_colors.dart';
import 'package:foodie_padi_apps/models/order_model.dart';
import 'package:foodie_padi_apps/providers/order_provider.dart';
import 'package:provider/provider.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  bool isCurrentSelected = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<OrdersProvider>().fetchOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          "My Orders",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            OrderTabs(
              isCurrentSelected: isCurrentSelected,
              onCurrentTap: () {
                setState(() => isCurrentSelected = true);
              },
              onPreviousTap: () {
                setState(() => isCurrentSelected = false);
              },
            ),
            const SizedBox(height: 16),

            /// 🔥 REAL ORDERS LIST
            Expanded(
              child: Consumer<OrdersProvider>(
                builder: (context, provider, _) {
                  if (provider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (provider.error != null) {
                    return Center(
                      child: Text(
                        provider.error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  final orders = isCurrentSelected
                      ? provider.currentOrders
                      : provider.previousOrders;

                  if (orders.isEmpty) {
                    return Center(
                      child: Text(
                        isCurrentSelected
                            ? "No current orders"
                            : "No previous orders",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      return OrderCard(order: orders[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final OrderModel order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrdersProvider>();

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            provider.getReadableStatus(order.status),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Vendor: ${order.vendorName}",
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 6),
          Text(
            "Total price paid ₦${order.totalPrice.toStringAsFixed(2)}",
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class OrderTabs extends StatelessWidget {
  final bool isCurrentSelected;
  final VoidCallback onCurrentTap;
  final VoidCallback onPreviousTap;

  const OrderTabs({
    super.key,
    required this.isCurrentSelected,
    required this.onCurrentTap,
    required this.onPreviousTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: AppColors.primaryOrange,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const SizedBox(width: 5),

          /// CURRENT TAB
          Expanded(
            child: GestureDetector(
              onTap: onCurrentTap,
              child: Container(
                height: 37,
                decoration: BoxDecoration(
                  color: isCurrentSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Current",
                        style: TextStyle(
                          color: isCurrentSelected
                              ? Colors.black
                              : AppColors.background,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (isCurrentSelected) ...[
                        const SizedBox(width: 6),
                        const CircleAvatar(
                          radius: 4,
                          backgroundColor: AppColors.primaryOrange,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),

          /// PREVIOUS TAB
          Expanded(
            child: GestureDetector(
              onTap: onPreviousTap,
              child: Container(
                height: 37,
                decoration: BoxDecoration(
                  color: !isCurrentSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    "Previous",
                    style: TextStyle(
                      color: !isCurrentSelected
                          ? Colors.black
                          : AppColors.background,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 5),
        ],
      ),
    );
  }
}
