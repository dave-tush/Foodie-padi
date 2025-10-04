class ReportModel {
  final String userId;
  final String reason;

  ReportModel({required this.userId, required this.reason});

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      userId: json['userId'],
      reason: json['reason'],
    );
  }
}
