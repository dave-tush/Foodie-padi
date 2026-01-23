import 'package:flutter/material.dart';
import 'package:foodie_padi_apps/models/notifications/notification_model.dart';
import 'package:foodie_padi_apps/services/notification_services.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationServices notificationServices;

  NotificationProvider({required this.notificationServices});

  bool _isLoading = false;
  String? _errorMessage;
  List<NotificationModel> _notifications = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<NotificationModel> get notifications => _notifications;

  int get unreadCount =>
      _notifications.where((n) => n.read == false).length;

  // ================= FETCH =================
  Future<void> fetchNotifications() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await notificationServices.fetchResponse();
      _notifications = response.notifications;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ================= MARK ONE =================
  Future<void> markNotificationAsRead(String id) async {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index == -1 || _notifications[index].read) return;

    final success = await notificationServices.markAsRead(id);
    if (success) {
      _notifications[index] =
          _notifications[index].copyWith(read: true);
      notifyListeners();
    }
  }

  // ================= MARK ALL =================
  Future<void> markAllAsRead() async {
    if (unreadCount == 0) return; // 🔥 important

    final success = await notificationServices.markAllRead();
    if (success) {
      _notifications = _notifications
          .map((n) => n.copyWith(read: true))
          .toList();
      notifyListeners();
    }
  }
}
