class ReplyModel {
  final String message;
  final String vendorId;
  final DateTime createdAt;
  final DateTime updatedAt;
  ReplyModel({
    required this.message,
    required this.vendorId,
    required this.createdAt,
    required this.updatedAt,
  });
  factory ReplyModel.fromJson(Map<String, dynamic> json) {
    return ReplyModel(
      message: json['message']?.toString() ?? '',
      vendorId: json['vendorId']?.toString() ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
