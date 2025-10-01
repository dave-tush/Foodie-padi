class CustomerModel {
  final String id;
  final String name;
  final String avatarUrl;

  CustomerModel({
    required this.id,
    required this.name,
    required this.avatarUrl,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
    );
  }
}
