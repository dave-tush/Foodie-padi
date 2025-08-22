import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_item.dart';
import '../providers/cart_provider.dart';

class CartItemTile extends StatelessWidget {
  final CartItem item;

  const CartItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.network(item.imageUrl, width: 60, height: 60),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(item.name,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                IconButton(
                  icon: Icon(Icons.remove_circle),
                  onPressed: () => cart.removeItem(item.id),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () => cart.decreaseQuantity(item.id),
                ),
                Text(item.quantity.toString()),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => cart.increaseQuantity(item.id),
                ),
              ],
            ),
            ...item.extras.map((e) => Padding(
                  padding: const EdgeInsets.only(left: 20, top: 4),
                  child: Row(
                    children: [
                      Text("Add ${e.name}"),
                      Spacer(),
                      Text("£ ${e.price.toStringAsFixed(2)}")
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
