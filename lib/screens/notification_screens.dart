import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodie_padi_apps/models/notifications/notification_model.dart';
import 'package:provider/provider.dart';
import '../../providers/notification_provider.dart';

class NotificationScreen extends StatefulWidget {
  static const routeName = '/notifications';

  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();

    /// Fetch + mark all as read when screen opens
    Future.microtask(() async {
      final provider = context.read<NotificationProvider>();
      await provider.fetchNotifications();
      provider.markAllAsRead();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: () {
              context.read<NotificationProvider>().markAllAsRead();
            },
          )
        ],
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, _) {
          if (provider.notifications.isEmpty) {
            return const Center(
              child: Text('No notifications yet'),
            );
          }

          return ListView.separated(
            padding: EdgeInsets.all(16.dg),
            itemCount: provider.notifications.length,
            separatorBuilder: (_, __) => SizedBox(height: 10.h),
            itemBuilder: (context, index) {
              final notification = provider.notifications[index];
              return _NotificationCard(notification: notification);
            },
          );
        },
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationModel notification;

  const _NotificationCard({required this.notification});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<NotificationProvider>();

    return GestureDetector(
      onTap: () {
        if (!notification.read) {
          provider.markNotificationAsRead(notification.id);
        }
      },
      child: Container(
        padding: EdgeInsets.all(14.dg),
        decoration: BoxDecoration(
          color:
              notification.read ? Colors.grey.shade100 : Colors.orange.shade50,
          borderRadius: BorderRadius.circular(12.dg),
          border: Border.all(
            color: notification.read ? Colors.grey.shade300 : Colors.orange,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _NotificationIcon(type: notification.type),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    notification.message,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    _formatDate(notification.createdAt),
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            if (!notification.read)
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _NotificationIcon extends StatelessWidget {
  final String type;

  const _NotificationIcon({required this.type});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;

    switch (type) {
      case 'PAYMENT':
        icon = Icons.payment;
        color = Colors.green;
        break;
      case 'ORDER':
        icon = Icons.receipt_long;
        color = Colors.blue;
        break;
      default:
        icon = Icons.notifications;
        color = Colors.orange;
    }

    return Container(
      padding: EdgeInsets.all(8.dg),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.dg),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }
}

String _formatDate(DateTime date) {
  final now = DateTime.now();
  final diff = now.difference(date);

  if (diff.inMinutes < 1) return 'Just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  return '${date.day}/${date.month}/${date.year}';
}
