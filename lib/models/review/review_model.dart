import 'package:foodie_padi_apps/models/review/reply_model.dart';
import 'package:foodie_padi_apps/models/review/report_model.dart';
import 'package:foodie_padi_apps/models/review/vote_model.dart';
import 'package:foodie_padi_apps/models/user_model.dart';

class ReviewModel {
  final String id;
  final User user;
  final int rating;
  final String comment;
  final List<String> images;
  final ReplyModel? reply;
  final List<VoteModel> votes;
  final List<ReportModel> reports;
  final DateTime createdAt;
  final DateTime updatedAt;
  ReviewModel({
    required this.id,
    required this.user,
    required this.rating,
    required this.comment,
    required this.images,
    this.reply,
    required this.votes,
    required this.reports,
    required this.createdAt,
    required this.updatedAt,
  });
  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id']?.toString() ?? '',
      user: User.fromJson(json['user'], ''),
      rating: json['rating'] ?? 0,
      comment: json['comment']?.toString() ?? '',
      images: json['images'] != null && json['images'] is List
          ? List<String>.from(json['images'])
          : [],
      reply: json['reply'] != null ? ReplyModel.fromJson(json['reply']) : null,
      votes: json['votes'] != null && json['votes'] is List
          ? (json['votes'] as List).map((v) => VoteModel.fromJson(v)).toList()
          : [],
      reports: json['reports'] != null && json['reports'] is List
          ? (json['reports'] as List)
              .map((r) => ReportModel.fromJson(r))
              .toList()
          : [],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class Review {
  final String id;
  final String userName;
  final String userAvatar;
  final String date;
  final int rating;
  final String comment;

  Review({
    required this.id,
    required this.userName,
    required this.userAvatar,
    required this.date,
    required this.rating,
    required this.comment,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      userName: json['userName'],
      userAvatar: json['userAvatar'] ?? '',
      date: json['date'],
      rating: json['rating'],
      comment: json['comment'],
    );
  }
}

class Reviews {
  final String id;
  final String productId;
  final String customerId;
  final int rating;
  final String comment;
  final List<String> images;
  final DateTime createdAt;
  final bool verifiedPurchase;
  final String userName;
  final String userAvatar;

  Reviews({
    required this.id,
    required this.productId,
    required this.customerId,
    required this.rating,
    required this.comment,
    required this.images,
    required this.createdAt,
    required this.verifiedPurchase,
    required this.userName,
    required this.userAvatar,
  });

  factory Reviews.fromJson(Map<String, dynamic> json) {
    final customer = json['customer'] ?? {};
    return Reviews(
      id: json['id'],
      productId: json['productId'],
      customerId: json['customerId'],
      rating: json['rating'],
      comment: json['comment'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      verifiedPurchase: json['verifiedPurchase'] ?? false,
      userName: customer['name'] ?? 'Anonymous',
      userAvatar: customer['avatarUrl'] ?? '',
    );
  }
}
