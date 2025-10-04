class VoteModel {
  final String UserId;
  final String reason;

  VoteModel({
    required this.UserId,
    required this.reason,
  });
  factory VoteModel.fromJson(Map<String, dynamic> json) {
    return VoteModel(
      UserId: json['UserId']?.toString() ?? '',
      reason: json['reason']?.toString() ?? '',
    );
  }
}
