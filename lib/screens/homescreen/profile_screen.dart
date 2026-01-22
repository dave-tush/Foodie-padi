import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodie_padi_apps/core/constants/app_colors.dart';
import 'package:foodie_padi_apps/providers/profile_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // ✅ specify provider type
    Future.microtask(() {
      final provider = Provider.of<ProfileProvider>(context, listen: false);
      provider.fetchProfile();
      provider.fetchCustomerOrderStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        if (profileProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = profileProvider.user;
        if (user == null) {
          return const Center(child: Text('No user data'));
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              "My Profile",
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // TODO: Navigate to Edit Profile Screen
                },
              )
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar
                CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                          ? NetworkImage(user.avatarUrl!)
                          : null,
                  child: (user.avatarUrl == null || user.avatarUrl!.isEmpty)
                      ? Text(user.name.isNotEmpty ? user.name[0] : "?",
                          style: const TextStyle(fontSize: 30))
                      : null,
                ),
                const SizedBox(height: 12),

                // Name + Username
                Text(user.name,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
                if (user.username != null)
                  Text("@${user.username}",
                      style: TextStyle(color: Colors.grey[600])),

                const SizedBox(height: 8),
                if (user.email != null) Text(user.email!),

                if (user.bio != null) ...[
                  const SizedBox(height: 12),
                  Text(user.bio!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontStyle: FontStyle.italic)),
                ],

                const SizedBox(height: 20),

                // Preferences

                const SizedBox(height: 20),
                const SizedBox(height: 20),

                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Order Statistics",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryOrange,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                if (profileProvider.isOrderStatsLoading)
                  const Center(child: CircularProgressIndicator())
                else if (profileProvider.orderStat != null) ...[
                  _statTile(
                    icon: Icons.shopping_bag,
                    title: "Total Orders",
                    value: profileProvider.orderStat!.totalOrders.toString(),
                    onTap: () {
                      // Navigator.push → OrdersScreen(filter: OrderFilter.all)
                    },
                  ),

                  _statTile(
                    icon: Icons.check_circle,
                    title: "Completed Orders",
                    value:
                        profileProvider.orderStat!.completedOrders.toString(),
                    onTap: () {
                      // Navigator.push → OrdersScreen(filter: OrderFilter.completed)
                    },
                  ),

                  _statTile(
                    icon: Icons.timelapse,
                    title: "In Progress Orders",
                    value:
                        profileProvider.orderStat!.inProgressOrders.toString(),
                    onTap: () {
                      // Navigator.push → OrdersScreen(filter: OrderFilter.inProgress)
                    },
                  ),

                  _statTile(
                    icon: Icons.payment,
                    title: "Awaiting Payment",
                    value: profileProvider.orderStat!.awaitingPaymentOrders
                        .toString(),
                    onTap: () {
                      // Navigator.push → OrdersScreen(filter: OrderFilter.awaitingPayment)
                    },
                  ),

                  _statTile(
                    icon: Icons.attach_money,
                    title: "Total Spent",
                    value:
                        "₦${profileProvider.orderStat!.totalSpent.toStringAsFixed(2)}",
                  ),

                  const SizedBox(height: 12),

                  /// Last 7 days orders
                  const Text(
                    "Last 7 Days Orders",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 6),

                  ...profileProvider.orderStat!.last7DaysOrders.map((day) {
                    return ListTile(
                      dense: true,
                      leading: const Icon(
                        Icons.calendar_today,
                        size: 18,
                        color: AppColors.primaryOrange,
                      ),
                      title: Text(day.date),
                      trailing: Text(
                        day.orders.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        // Optional: show orders for this specific date
                      },
                    );
                  }).toList(),
                ] else
                  const Text(
                    "No order statistics available",
                    style: TextStyle(color: Colors.grey),
                  ),

                // Address
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text("Address",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryOrange)),
                ),
                const SizedBox(height: 10),
                ListTile(
                  leading: const Icon(
                    Icons.location_on,
                    color: AppColors.primaryOrange,
                  ),
                  title: Text(user.address?.first.street ?? "No address"),
                  subtitle: Text(user.address?.first.city ?? "No city"),
                  trailing: Text(user.address?.first.state ?? "No state"),
                ),
                SizedBox(height: 16.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text("Address",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryOrange)),
                ),

                // Role
                ListTile(
                  leading: const Icon(Icons.person),
                  title: Text("Role: ${user.role ?? 'Unknown'}"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget _statTile({
  required IconData icon,
  required String title,
  required String value,
  VoidCallback? onTap,
}) {
  return Card(
    elevation: 1,
    child: ListTile(
      leading: Icon(icon, color: AppColors.primaryOrange),
      title: Text(title),
      trailing: Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      onTap: onTap,
    ),
  );
}
