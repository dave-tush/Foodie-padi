import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../providers/food_provider.dart';
import '../../services/upload_food_services.dart';

class FoodUploadScreen extends StatelessWidget {
  const FoodUploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FoodProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Upload Food Item")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextFormField(
            decoration: const InputDecoration(labelText: "Name"),
            onChanged: provider.updateName,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: "Description"),
            onChanged: provider.updateDescription,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: "Price"),
            keyboardType: TextInputType.number,
            onChanged: provider.updatePrice,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: "Availability"),
            onChanged: provider.updateAvailability,
          ),
          SwitchListTile(
            title: const Text("Available"),
            value: provider.foodItem.available,
            onChanged: provider.updateAvailable,
          ),
          DropdownButtonFormField<String>(
            value: provider.foodItem.category.isEmpty
                ? null
                : provider.foodItem.category,
            items: const [
              DropdownMenuItem(value: 'FOOD', child: Text("FOOD")),
              DropdownMenuItem(value: 'DRINK', child: Text("DRINK")),
              DropdownMenuItem(value: 'SNACK', child: Text("SNACK")),
            ],
            onChanged: (value) {
              if (value != null) provider.updateCategory(value);
            },
            decoration: const InputDecoration(labelText: "Category"),
          ),
          ListTile(
            title: const Text("Order Open At"),
            subtitle: Text(provider.foodItem.orderOpenAt.toIso8601String()),
            onTap: () async {
              DateTime? picked = await showDatePicker(
                context: context,
                initialDate: provider.foodItem.orderOpenAt,
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
              );
              if (picked != null) provider.updateOpenAt(picked);
            },
          ),
          ListTile(
            title: const Text("Order Close At"),
            subtitle: Text(provider.foodItem.orderCloseAt.toIso8601String()),
            onTap: () async {
              DateTime? picked = await showDatePicker(
                context: context,
                initialDate: provider.foodItem.orderCloseAt,
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
              );
              if (picked != null) provider.updateCloseAt(picked);
            },
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: "Options (JSON)"),
            onChanged: provider.updateOptionsFromJson,
            maxLines: 3,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              final picker = ImagePicker();
              final picked = await picker.pickMultiImage();
              if (picked.isNotEmpty) {
                provider.setImage(picked);
              }
            },
            child: const Text("Select Images"),
          ),
          Text("${provider.foodItem.images.length} images selected"),
          ElevatedButton(
            onPressed: () async {
              final picker = ImagePicker();
              final picked =
                  await picker.pickVideo(source: ImageSource.gallery);
              if (picked != null) {
                provider.setVideo(picked);
              }
            },
            child: const Text("Select Video"),
          ),
          if (provider.foodItem.video != null)
            Text("Video selected: ${provider.foodItem.video!.name}"),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              final yourToken = prefs.getString('access_token') ?? '';
              if (yourToken.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please login first")),
                );
                return;
              }

              if (provider.foodItem.name.isEmpty ||
                  provider.foodItem.description.isEmpty ||
                  provider.foodItem.price <= 0 ||
                  provider.foodItem.category.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please fill all fields")),
                );
                return;
              }

              if (provider.foodItem.images.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Please select at least one image")),
                );
                return;
              }

              try {
                final response = await FoodService().uploadFood(
                  token: yourToken,
                  food: provider.foodItem,
                );

                if (response.statusCode == 200 || response.statusCode == 201) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Upload successful")),
                  );
                } else {
                  final error = await response.stream.bytesToString();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Upload failed: $error")),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Connection error: $e")),
                );
              }
            },
            child: const Text("Submit"),
          )
        ]),
      ),
    );
  }
}
