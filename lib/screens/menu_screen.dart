import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/menu_provider.dart';
import 'review_screen.dart';

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final menu = Provider.of<MenuProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('About This Menu'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              menu.imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            menu.title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            '£${menu.basePrice.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 18, color: Colors.red),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.star, color: Colors.amber),
              SizedBox(width: 4),
              Text('4.9 (1,205)', style: TextStyle(fontSize: 14)),
              Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ReviewsScreen(
                              productId: 'menu.id',
                            )),
                  );
                },
                child: Text('See all reviews'),
              )
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'A delicious meal of ${menu.title.toLowerCase()} best enjoyed hot with fresh agege bread and extras like ponmo and eja kika.',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 20),
          Text('Additional Options:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          CheckboxListTile(
            title: Text('Add Ponmo (+£0.50)'),
            value: menu.addPonmo,
            onChanged: menu.togglePonmo,
          ),
          CheckboxListTile(
            title: Text('Add Eja Kika (+£1.00)'),
            value: menu.addEjaKika,
            onChanged: menu.toggleEjaKika,
          ),
          ListTile(
            title: Text('Add Meat'),
          ),
          RadioListTile<String>(
            title: Text('Extra Beef (+£2.00)'),
            value: 'Extra Beef',
            groupValue: menu.meatOption,
            onChanged: (value) => menu.setMeatOption(value!),
          ),
          RadioListTile<String>(
            title: Text('Double Chicken (+£3.50)'),
            value: 'Double Chicken',
            groupValue: menu.meatOption,
            onChanged: (value) => menu.setMeatOption(value!),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Quantity Controls
              Row(
                children: [
                  IconButton(
                    onPressed: menu.decrementQty,
                    icon: Icon(Icons.remove_circle_outline),
                  ),
                  Text(
                    '${menu.quantity}',
                    style: TextStyle(fontSize: 18),
                  ),
                  IconButton(
                    onPressed: menu.incrementQty,
                    icon: Icon(Icons.add_circle_outline),
                  ),
                ],
              ),
              // Add to Cart Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                onPressed: () {
                  // TODO: Add to cart logic here
                },
                child: Text(
                  'Add to Cart (£${menu.totalPrice.toStringAsFixed(2)})',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
