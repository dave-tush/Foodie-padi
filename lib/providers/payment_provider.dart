import 'package:flutter/cupertino.dart';
import 'package:flutter_paystack_plus/flutter_paystack_plus.dart';
import 'package:foodie_padi_apps/models/card_model.dart';
import 'package:foodie_padi_apps/services/payment_service.dart';

class PaymentProvider extends ChangeNotifier {
  final PaymentService paymentService;
  bool isProcessing = false;
  PaymentProvider(this.paymentService);

  List<CardModel> _cards = [];
  bool _isLoading = false;
  CardModel? _selectedCard;

  CardModel? get selectedCard => _selectedCard;
  bool get isLoading => _isLoading;
  List<CardModel> get cards => _cards;

  Future<void> initializePaystack(String publicKey) async {
    //await _paystack.initialize(publicKey: publicKey);
  }
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

  Future<Map<String, dynamic>?> startPayment(String orderId) async {
    isProcessing = true;
    notifyListeners();
    try {
      final data = await paymentService.startPayment(
        orderId: orderId,
        token: paymentService.token, // reuse the token from the service
      );

      return data;
    } finally {
      isProcessing = false;
      notifyListeners();
    }
  }
}
