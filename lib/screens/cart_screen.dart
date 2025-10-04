import 'package:flutter/material.dart';
import 'package:foodie_padi_apps/models/cart/cart_model.dart';
import 'package:foodie_padi_apps/screens/payment_methods.dart';
import 'package:provider/provider.dart';
import 'package:foodie_padi_apps/core/constants/app_colors.dart';
import 'package:foodie_padi_apps/providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cart = cartProvider.cart;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Carts"),
      ),
      body: cart == null || cart.items.isEmpty
          ? const Center(
              child: Text("Your cart is empty"),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Order Summary
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Order Summary",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // go back to add items
                        },
                        child: const Text("Add Items"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  /// Cart Items List
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final CartItem item = cart.items[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// Product Image
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      item.product.images.isNotEmpty
                                          ? item.product.images[0]
                                          : "https://via.placeholder.com/80",
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  /// Product Info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.product.name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "£${item.unitPrice.toStringAsFixed(2)}",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  /// Delete Icon
                                  IconButton(
                                    onPressed: () {
                                      cartProvider.removeCartItem(item.id);
                                    },
                                    icon: const Icon(Icons.close,
                                        color: Colors.red),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),

                              /// Selected Options (Add-ons)
                              if (item.options.isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: item.options.map((opt) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 4.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(opt.name ?? "Option"),
                                          Text(
                                            "£${opt.price?.toStringAsFixed(2) ?? "0.00"}",
                                            style: const TextStyle(
                                                color: Colors.red),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),

                              /// Quantity Controls
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle),
                                    onPressed: () {
                                      if (item.quantity > 1) {
                                        cartProvider.updateCartItem(
                                          item.id,
                                          item.quantity - 1,
                                          item.options
                                              .map((e) => e.id)
                                              .toList(),
                                        );
                                      }
                                    },
                                  ),
                                  Text(
                                    "${item.quantity}",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle),
                                    onPressed: () {
                                      cartProvider.updateCartItem(
                                        item.id,
                                        item.quantity + 1,
                                        item.options.map((e) => e.id).toList(),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  /// Delivery Address
                  ListTile(
                    leading: const Icon(Icons.location_on,
                        color: AppColors.secondaryYellow),
                    title: const Text("Deliver to"),
                    subtitle: const Text("Shalom Hostel, under G"),
                    trailing: const Icon(Icons.edit),
                    onTap: () {
                      // TODO: Navigate to address selection
                    },
                  ),
                  const Divider(),

                  /// Payment Method
                  ListTile(
                    leading: const Icon(Icons.payment,
                        color: AppColors.secondaryYellow),
                    title: const Text("Payment method"),
                    subtitle: const Text("Transfer"),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: Navigate to payment method selection
                    },
                  ),
                  const Divider(),

                  /// Promotions
                  ListTile(
                    leading: const Icon(Icons.local_offer,
                        color: AppColors.secondaryYellow),
                    title: const Text("Promotions"),
                    subtitle: const Text("FREE DELIVERY 20%"),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: Navigate to promo code selection
                    },
                  ),
                  const Divider(),

                  /// Payment Summary
                  const SizedBox(height: 10),
                  const Text(
                    "Payment Summary",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total Items (${cart.items.length})"),
                      Text("£${cartProvider.totalPrice.toStringAsFixed(2)}"),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Delivery Fee"),
                      Text("£3.32"),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Discount"),
                      Text("-£1.32", style: TextStyle(color: Colors.redAccent)),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "£${cartProvider.totalPrice.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  /// Place Order
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        final result = await cartProvider.checkout(
                          addressId: "yourAddressIdHere",
                          specialRequest: "",
                        );
                        if (result != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Order placed successfully!")),
                          );
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => PaymentMethodsScreen()));
                        }
                      },
                      child: const Text(
                        "Place Order",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
