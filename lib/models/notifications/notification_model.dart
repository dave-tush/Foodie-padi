class NotificationModel {
  final String id;
  final String userId;
  final String title;
  final String message;
  final String type;
  final Map<String, dynamic> metadata;
  bool read;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    required this.metadata,
    required this.read,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      message: json['message'],
      type: json['type'],
      metadata: json['metadata'] ?? {},
      read: json['read'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
  NotificationModel copyWith({
    bool? read,
  }) {
    return NotificationModel(
      id: id,
      userId: userId,
      title: title,
      message: message,
      type: type,
      metadata: metadata,
      read: read ?? this.read,
      createdAt: createdAt,
    );
  }
}
