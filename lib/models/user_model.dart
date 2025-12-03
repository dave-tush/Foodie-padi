import 'package:foodie_padi_apps/models/address.dart';

class User {
  final String id;
  final String name;
  final String? email;
  final String? username;
  final String? role;
  final String? phoneNumber;
  final String? avatarUrl;
  final List<dynamic> preferences;
  final String? bio;
  final List<Address>? address;
  final String? brandName;
  final String? brandLogo;
  final String token;

  User({
    required this.id,
    required this.name,
    this.email,
    this.username,
    this.role,
    this.phoneNumber,
    this.avatarUrl,
    required this.preferences,
    this.bio,
    this.address,
    this.brandName,
    this.brandLogo,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json, String? token) {
    return User(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString(),
      username: json['username']?.toString(),
      role: json['role']?.toString(),
      phoneNumber: json['phoneNumber']?.toString(),
      avatarUrl: json['avatarUrl']?.toString(),
      preferences: json['preferences'] is List ? json['preferences'] : [],
      bio: json['bio']?.toString(),
      address: json['addresses'] != null && json['addresses'] is List
          ? (json['addresses'] as List)
              .map((addr) => Address.fromJson(addr))
              .toList()
          : [],
      brandName: json['brandName']?.toString(),
      brandLogo: json['brandLogo']?.toString(),
      token: token ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'username': username,
      'role': role,
      'phoneNumber': phoneNumber,
      'avatarUrl': avatarUrl,
      'preferences': preferences,
      'bio': bio,
      'addresses':
          address?.map((addr) => addr.toJson()).toList() ?? [], // ✅ safe
      'brandName': brandName,
      'brandLogo': brandLogo,
      'token': token,
    };
  }
}
