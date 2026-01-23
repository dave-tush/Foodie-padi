import 'package:foodie_padi_apps/models/notifications/notification_model.dart';

class NotificationsResponse {
  final int unreadCount;
  final List<NotificationModel> notifications;

  NotificationsResponse({
    required this.unreadCount,
    required this.notifications,
  });

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) {
    final notifs = (json['notifications'] as List<dynamic>? ?? [])
        .map((e) => NotificationModel.fromJson(e))
        .toList();

    return NotificationsResponse(
      unreadCount: json['unreadCount'] ?? 0,
      notifications: notifs,
    );
  }
}
