import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:foodie_padi_apps/widgets/chart.dart';
import 'package:provider/provider.dart' show Provider;

import '../../models/vendor_model.dart';
import '../../providers/vendor_provider.dart';

class VendorHomeScreen extends StatefulWidget {
  const VendorHomeScreen({super.key});

  @override
  State<VendorHomeScreen> createState() => _VendorHomeScreenState();
}

class _VendorHomeScreenState extends State<VendorHomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Handle navigation logic here
    switch (index) {
      case 0:
        // Already on Home
        break;
      case 1:
        Navigator.pushNamed(context, '/orders');
        break;
      case 2:
        Navigator.pushNamed(context, '/addMeal');
        break;
      case 3:
        Navigator.pushNamed(context, '/chat');
        break;
      case 4:
        Navigator.pushNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final vendorProvider = Provider.of<VendorProvider>(context);
    final vendor = vendorProvider.vendor;

    if (vendor == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Vendor Dashboard"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LineChartSample2(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildDashboard(Vendor vendor, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("LOCATION: ${vendor.location}",
            style: const TextStyle(color: Colors.orange)),
        const SizedBox(height: 8),
        Text("Welcome back,", style: Theme.of(context).textTheme.titleMedium),
        Text(vendor.name, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStatCard("CURRENT ORDERS", vendor.currentOrders.toString()),
            _buildStatCard("SPECIAL ORDER", vendor.specialOrders.toString()),
          ],
        ),
        const SizedBox(height: 24),
        Text("Total Sales: ₦${vendor.totalSales.toStringAsFixed(0)}"),
        const SizedBox(height: 8),
        SizedBox(
          height: 150,
          child: LineChart(
            LineChartData(
              lineBarsData: [
                LineChartBarData(
                  spots: vendor.sales.asMap().entries.map((e) {
                    return FlSpot(e.key.toDouble(), e.value.amount);
                  }).toList(),
                  isCurved: true,
                  color: Colors.orange,
                  barWidth: 3,
                ),
              ],
              titlesData: FlTitlesData(
                leftTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, _) {
                      final index = value.toInt();
                      if (index >= 0 && index < vendor.sales.length) {
                        return Text(vendor.sales[index].time,
                            style: const TextStyle(fontSize: 10));
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Icon(Icons.star, color: Colors.orange),
            const SizedBox(width: 4),
            Text("${vendor.averageRating}"),
            Text("  Total ${vendor.totalReviews} Reviews"),
          ],
        ),
        SizedBox(
          height: 50,
          child: LineChartSample2(),
        )
      ],
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(value,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(title,
                style: const TextStyle(fontSize: 12, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}
