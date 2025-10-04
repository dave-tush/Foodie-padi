import 'package:flutter/cupertino.dart';
import 'package:foodie_padi_apps/models/card_model.dart';
import 'package:foodie_padi_apps/services/payment_service.dart';

class PaymentProvider extends ChangeNotifier {
  final PaymentService paymentService;
  PaymentProvider(this.paymentService);

  List<CardModel> _cards = [];
  bool _isLoading = false;
  CardModel? _selectedCard;

  CardModel? get selectedCard => _selectedCard;
  bool get isLoading => _isLoading;
  List<CardModel> get cards => _cards;

  Future<void> fetchCards() async {
    _isLoading = true;
    notifyListeners();
    try {
      _cards = await paymentService.getSavedCard();
    } catch (e) {
      _cards = [];
      print("Error fetching cards: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectCard(CardModel card) {
    _selectedCard = card;
    notifyListeners();
  }

  Future<Map<String, dynamic>> makePayment(double amount) async {
    if (_selectedCard == null) {
      throw Exception("No card selected");
    }
    return await paymentService.startPayment(
        id: _selectedCard!.id, amount: amount);
  }
}
