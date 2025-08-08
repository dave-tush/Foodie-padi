import 'package:image_picker/image_picker.dart';

class FoodItem {
  String name;
  String description;
  double price;
  String availability;
  bool available;
  // String imageUrl;
  // String vendorId;
  String category;
  DateTime orderOpenAt;
  DateTime orderCloseAt;
  List<Option> options;
  List<XFile> images;
  XFile? video;

  FoodItem({
    required this.name,
    required this.description,
    required this.availability,
    required this.price,
    required this.available,
    required this.category,
    required this.orderOpenAt,
    required this.orderCloseAt,
    required this.options,
    required this.images,
    this.video,
  });
}

class Option {
  String name;
  double price;

  Option({required this.name, required this.price});

  Map<String, dynamic> toJson() => {
        'name': name,
        'price': price,
      };

  factory Option.fromJson(Map<String, dynamic> json) =>
      Option(name: json['name'], price: (json['price'] ?? 0).toDouble());
}
