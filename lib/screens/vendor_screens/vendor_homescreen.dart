import 'package:flutter/material.dart';
import 'package:foodie_padi_apps/models/vendor/vendor_dashboard_model.dart';
import 'package:provider/provider.dart';
import 'package:foodie_padi_apps/providers/vendor_provider.dart';
import 'package:foodie_padi_apps/providers/vendor_dashboard_provider.dart';
import 'package:foodie_padi_apps/widgets/chart.dart';

class VendorHomeScreens extends StatefulWidget {
  const VendorHomeScreens({super.key});

  @override
  State<VendorHomeScreens> createState() => _VendorHomeScreenState();
}

class _VendorHomeScreenState extends State<VendorHomeScreens> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchDashboard();
  }

  Future<void> _fetchDashboard() async {
    final vendorProvider = Provider.of<VendorProvider>(context, listen: false);
    final vendor = vendorProvider.vendor;
    if (vendor != null) {
      await Provider.of<VendorDashboardProvider>(context, listen: false);
      // .loadDashboard(vendor.token, vendor.id);
    }
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    switch (index) {
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
    final dashboardProvider = Provider.of<VendorDashboardProvider>(context);
    final dashboard = dashboardProvider.dashboard;

    if (dashboardProvider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (dashboardProvider.error != null) {
      return Scaffold(body: Center(child: Text(dashboardProvider.error!)));
    }

    if (dashboard == null) {
      return const Scaffold(body: Center(child: Text("No data available")));
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.orange,
                    child: Icon(Icons.store, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("LOCATION",
                          style: TextStyle(color: Colors.orange)),
                      Text(
                        vendorProvider.vendor?.name ?? 'Vendor',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Stack(
                    children: [
                      IconButton(
                        icon:
                            const Icon(Icons.notifications_outlined, size: 28),
                        onPressed: () {},
                      ),
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: const BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text("2",
                                style: TextStyle(
                                    fontSize: 10, color: Colors.white)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Text(
                "Welcome back,\n${vendorProvider.vendor?.name ?? "Vendor"}!",
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 24),
              Row(
                children: [
                  _buildStatCard("CURRENT ORDERS", dashboard.currentOrders),
                  const SizedBox(width: 10),
                  _buildStatCard("SPECIAL ORDER", dashboard.specialOrders),
                ],
              ),

              const SizedBox(height: 24),
              _buildSalesCard(dashboard),

              const SizedBox(height: 24),
              _buildReviewCard(dashboard),
            ],
          ),
        ),
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

  Widget _buildStatCard(String title, int value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text("$value",
                style:
                    const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            Text(title, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesCard(VendorDashboard dashboard) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total Sales",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text("\$${dashboard.totalSales}",
                  style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 200,
            child: LineChartSample2(salesData: dashboard.salesTimeline),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(VendorDashboard dashboard) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.star, color: Colors.orange),
          const SizedBox(width: 6),
          Text("${dashboard.averageRating}",
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(width: 6),
          Text("Total ${dashboard.totalReviews} Reviews"),
          const Spacer(),
          const Text("See All Reviews",
              style:
                  TextStyle(color: Colors.orange, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
