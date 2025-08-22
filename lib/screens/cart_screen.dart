import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_item_tile.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Carts")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Order Summary",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextButton(onPressed: () {}, child: Text("Add Items"))
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.item.length,
              itemBuilder: (ctx, i) => CartItemTile(item: cart.item[i]),
            ),
          ),
          Divider(),
          ListTile(
            title: Text("Deliver to"),
            subtitle: Text("Hostel - Shalom Hostel, under G"),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            title: Text("Payment method"),
            subtitle: Text("Transfer"),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            title: Text("Promotions"),
            subtitle: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(4)),
                  child: Text("FREE DELIVERY",
                      style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                      color: Colors.yellow[800],
                      borderRadius: BorderRadius.circular(4)),
                  child: Text("20%", style: TextStyle(color: Colors.white)),
                )
              ],
            ),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total Items (${cart.item.length})"),
                    Text("£ ${cart.totalPrice.toStringAsFixed(2)}")
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Delivery Fee"),
                    Text("£ ${cart.deliveryFee.toStringAsFixed(2)}")
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Discount"),
                    Text("-£ ${cart.discount.toStringAsFixed(2)}")
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("£ ${cart.finalTotal.toStringAsFixed(2)}")
                  ],
                ),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Colors.orange,
                ),
                onPressed: () {},
                child: Text("Place Order"),
              ),
            ),
          )
        ],
      ),
    );
  }
}
