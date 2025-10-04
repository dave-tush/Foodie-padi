import 'package:flutter/material.dart';
import 'package:foodie_padi_apps/models/card_model.dart';
import 'package:foodie_padi_apps/providers/payment_provider.dart';
import 'package:provider/provider.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
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
          return const Center(child: CircularProgressIndicator());
        }

        final cards = paymentProvider.cards;

        return Scaffold(
          appBar: AppBar(title: const Text("Payment Methods")),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Payment method options (Cash, Transfer, Card)
              SizedBox(
                height: 90,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildMethodIcon("Cash", Icons.money),
                    _buildMethodIcon("Transfer", Icons.compare_arrows),
                    _buildMethodIcon("Card", Icons.credit_card, isActive: true),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: cards.isEmpty
                    ? _buildEmptyCardState()
                    : ListView.builder(
                        itemCount: cards.length,
                        itemBuilder: (context, index) {
                          final card = cards[index];
                          return ListTile(
                            leading: Icon(Icons.credit_card),
                            title: Text("**** **** **** ${card.last4}"),
                            subtitle: Text(card.brand.toUpperCase()),
                            trailing: Radio<CardModel>(
                              value: card,
                              groupValue: paymentProvider.selectedCard,
                              onChanged: (val) {
                                if (val != null) {
                                  paymentProvider.selectCard(val);
                                }
                              },
                            ),
                          );
                        },
                      ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Navigate to Add Card Screen
                      },
                      icon: const Icon(Icons.add, color: Colors.red),
                      label: const Text("Add New Card",
                          style: TextStyle(color: Colors.red)),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Call API /start payment
                      },
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          backgroundColor: Colors.orange),
                      child: const Text("Apply"),
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

  Widget _buildMethodIcon(String label, IconData icon,
      {bool isActive = false}) {
    return Container(
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
          Text(label,
              style: TextStyle(
                  color: isActive ? Colors.orange : Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildEmptyCardState() {
    return Center(
      child: Column(
        children: [
          Icon(Icons.credit_card, size: 100, color: Colors.orange),
          const SizedBox(height: 12),
          const Text("No card added",
              style: TextStyle(fontWeight: FontWeight.bold)),
          const Text("You can add any card and save it for later"),
        ],
      ),
    );
  }
}
