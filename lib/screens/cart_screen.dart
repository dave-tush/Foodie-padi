import 'package:flutter/material.dart';
import 'package:foodie_padi_apps/widgets/button.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool content = false;
    Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Carts")),
      body: content == true
          ? Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Ouch! Hungry?'),
                    Text(
                        'Seems like you have not added any items to your cart yet.'),
                    button(text: Text('Find'), onPressed: () {}),
                  ],
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Order Summary'),
                      Container(
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(18)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Add Items'),
                          ))
                    ],
                  )
                ],
              ),
            ),
    );
  }
}
