import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/food_item_model.dart';

class FoodProvider extends ChangeNotifier {
  FoodItem foodItem = FoodItem(
      name: '',
      description: '',
      availability: '',
      price: 0,
      available: true,
      category: 'FOOD',
      orderOpenAt: DateTime.now(),
      orderCloseAt: DateTime.now(),
      options: [],
      images: []);

  void updateName(String value) {
    foodItem.name = value;
    notifyListeners();
  }

  void updateDescription(String value) {
    foodItem.description = value;
    notifyListeners();
  }

  void updatePrice(String value) {
    foodItem.price = double.tryParse(value) ?? 0;
    notifyListeners();
  }

  void updateAvailability(String value) {
    foodItem.availability = value;
    notifyListeners();
  }

  void updateAvailable(bool value) {
    foodItem.available = value;
    notifyListeners();
  }

  void updateOpenAt(DateTime dateTime) {
    foodItem.orderOpenAt = dateTime;
    notifyListeners();
  }

  void updateCloseAt(DateTime dateTime) {
    foodItem.orderCloseAt = dateTime;
    notifyListeners();
  }

  void updateCategory(String value) {
    foodItem.category = value;
    notifyListeners();
  }

  void updateOptionsFromJson(String jsonString) {
    try {
      List<dynamic> parsed = jsonDecode(jsonString);
      foodItem.options = parsed.map((e) => Option.fromJson(e)).toList();
      notifyListeners();
    } catch (e) {}
  }

  void setImage(List<XFile> files) {
    foodItem.images = files;
    notifyListeners();
  }

  void setVideo(XFile file) {
    foodItem.video = file;
    notifyListeners();
  }
}
