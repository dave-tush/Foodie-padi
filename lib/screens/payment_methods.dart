import 'package:flutter/material.dart';
import 'package:foodie_padi_apps/models/card_model.dart';
import 'package:foodie_padi_apps/providers/payment_provider.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:foodie_padi_apps/models/card_model.dart';
import 'package:foodie_padi_apps/providers/payment_provider.dart';
import 'package:provider/provider.dart';

class PaymentMethodsScreen extends StatefulWidget {
  final String orderId;
  const PaymentMethodsScreen({super.key, required this.orderId});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  String selectedMethod = "Card"; // Default payment method

  @override
  void initState() {
    super.initState();
    Provider.of<PaymentProvider>(context, listen: false).fetchCards();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PaymentProvider>(
      builder: (context, paymentProvider, child) {
        if (paymentProvider.isLoading) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        final cards = paymentProvider.cards;

        return Scaffold(
          appBar: AppBar(title: const Text("Payment Methods")),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Payment method options ---
              SizedBox(
                height: 90,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildMethodIcon(
                      "Cash",
                      Icons.money,
                      isActive: selectedMethod == "Cash",
                      onTap: () => setState(() => selectedMethod = "Cash"),
                    ),
                    _buildMethodIcon(
                      "Transfer",
                      Icons.compare_arrows,
                      isActive: selectedMethod == "Transfer",
                      onTap: () => setState(() => selectedMethod = "Transfer"),
                    ),
                    _buildMethodIcon(
                      "Card",
                      Icons.credit_card,
                      isActive: selectedMethod == "Card",
                      onTap: () => setState(() => selectedMethod = "Card"),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // --- Card Section (visible only when Card selected) ---
              if (selectedMethod == "Card")
                Expanded(child: _buildCardSection(cards, paymentProvider)),

              // --- Action Buttons ---
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    if (selectedMethod == "Card")
                      OutlinedButton.icon(
                        onPressed: () {
                          // TODO: Navigate to Add Card Screen
                        },
                        icon: const Icon(Icons.add, color: Colors.red),
                        label: const Text(
                          "Add New Card",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        await _handlePayment(context, paymentProvider);
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        backgroundColor: Colors.orange,
                      ),
                      child: Text(
                        paymentProvider.isLoading
                            ? "Processing..."
                            : "Continue",
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  /// Handles button click based on selected payment method
  Future<void> _handlePayment(
      BuildContext context, PaymentProvider paymentProvider) async {
    if (selectedMethod == "Cash") {
      // 💵 Cash on Delivery logic
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cash on delivery selected")),
      );
      // Optionally call backend to mark order as "Pay on Delivery"
      return;
    }

    if (selectedMethod == "Transfer") {
      // 🏦 Bank Transfer Flow
      // await paymentProvider.startPayment(
      // orderId: widget.orderId,
      // mobileSdk: false, // Web/Transfer flow
      // context: context,
      // );
      return;
    }

    if (selectedMethod == "Card") {
      final selectedCard = paymentProvider.selectedCard;
      if (selectedCard == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select a card")),
        );
        return;
      }

      // await paymentProvider.chargeSavedCard(
      // orderId: widget.orderId,
      // cardId: selectedCard.id,
      // context: context,
      // );
    }
  }

  Widget _buildMethodIcon(
    String label,
    IconData icon, {
    bool isActive = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isActive ? Colors.orange : Colors.grey.shade300,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isActive ? Colors.orange.withOpacity(0.1) : Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isActive ? Colors.orange : Colors.grey),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.orange : Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardSection(List<CardModel> cards, PaymentProvider provider) {
    if (cards.isEmpty) return _buildEmptyCardState();

    return ListView.builder(
      itemCount: cards.length,
      itemBuilder: (context, index) {
        final card = cards[index];
        return ListTile(
          leading: const Icon(Icons.credit_card),
          title: Text("**** **** **** ${card.last4}"),
          subtitle: Text(card.brand.toUpperCase()),
          trailing: Radio<CardModel>(
            value: card,
            groupValue: provider.selectedCard,
            onChanged: (val) {
              if (val != null) provider.selectCard(val);
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyCardState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.credit_card, size: 100, color: Colors.orange),
          const SizedBox(height: 12),
          const Text("No card added",
              style: TextStyle(fontWeight: FontWeight.bold)),
          const Text("You can add a card and save it for later payments"),
        ],
      ),
    );
  }
}
