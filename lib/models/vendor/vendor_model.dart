class VendorModel {
  final String id;
  final String username;
  final String name;
  final String email;
  final String avatarUrl;
  final String bio;
  final List<String> preferences;
  final String role;
  final String createdAt;

  VendorModel({
    required this.id,
    required this.username,
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.bio,
    required this.preferences,
    required this.role,
    required this.createdAt,
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    return VendorModel(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      bio: json['bio'] ?? '',
      preferences: List<String>.from(json['preferences'] ?? []),
      role: json['role'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }
}
