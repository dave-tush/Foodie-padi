import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../models/food_item_model.dart';

import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class FoodService {
  Future<http.StreamedResponse> uploadFood({
    required String token,
    required FoodItem food,
  }) async {
    final uri =
        Uri.parse("https://food-paddi-backend.onrender.com/api/product");

    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token';

    // Fields
    request.fields['name'] = food.name;
    request.fields['description'] = food.description;
    request.fields['price'] = food.price.toString();
    request.fields['availability'] = food.availability;
    request.fields['available'] = food.available.toString();
    request.fields['category'] = food.category;
    request.fields['order_open_at'] = food.orderOpenAt.toIso8601String();
    request.fields['order_close_at'] = food.orderCloseAt.toIso8601String();
    //request.fields['options'] = food.optionsJson;

    // Images
    for (var image in food.images) {
      final mimeType = lookupMimeType(image.path) ?? 'image/jpeg';
      request.files.add(await http.MultipartFile.fromPath(
        'images',
        image.path,
        contentType: MediaType.parse(mimeType),
      ));
    }

    // Video
    if (food.video != null) {
      final mimeType = lookupMimeType(food.video!.path) ?? 'video/mp4';
      request.files.add(await http.MultipartFile.fromPath(
        'video',
        food.video!.path,
        contentType: MediaType.parse(mimeType),
      ));
    }

    return await request.send().timeout(const Duration(seconds: 20));
  }
}

final String baseUrl = 'https://food-paddi-backend.onrender.com';
Future<http.StreamedResponse> uploadFood({
  required String token,
  required FoodItem food,
}) async {
  final url = Uri.parse('$baseUrl/api/product/');
  final request = http.MultipartRequest('POST', url);
  request.headers['Authorization'] = 'Bearer $token';

  request.fields['name'] = food.name;
  request.fields['description'] = food.description;
  request.fields['price'] = food.price.toString();
  request.fields['availability'] = food.availability;
  request.fields['available'] = food.available.toString();
  request.fields['category'] = food.category;
  request.fields['orderOpenAt'] = food.orderOpenAt.toIso8601String();
  request.fields['orderCloseAt'] = food.orderCloseAt.toIso8601String();
  request.fields['options'] = jsonEncode(food.options
      .map(
        (e) => e.toJson(),
      )
      .toList());

  for (var image in food.images) {
    request.files.add(await http.MultipartFile.fromPath('images', image.path,
        filename: image.name, contentType: MediaType('image', 'jpeg')));
  }
  if (food.video != null) {
    request.files.add(await http.MultipartFile.fromPath(
        'video', food.video!.path,
        filename: food.video!.name, contentType: MediaType('video', 'mp4')));
  }
  final response = await request.send();
  if (response.statusCode == 200 || response.statusCode == 201) {
    print('Food item uploaded successfully');
  } else {
    print('Failed to upload food item: ${response.statusCode}');
  }
  return response;
}
