import 'package:flutter/material.dart';
import 'package:foodie_padi_apps/services/payment_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebviewScreen extends StatefulWidget {
  final String paymentUrl;
  final String reference;
  final String token;
  const PaymentWebviewScreen(
      {super.key,
      required this.paymentUrl,
      required this.reference,
      required this.token});

  @override
  State<PaymentWebviewScreen> createState() => _PaymentWebviewScreenState();
}

class _PaymentWebviewScreenState extends State<PaymentWebviewScreen> {
  late final WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.paymentUrl))
      ..setNavigationDelegate(NavigationDelegate(onPageStarted: (_) {
        setState(() {
          isLoading = true;
        });
      }, onNavigationRequest: (NavigationRequest request) {
        if (request.url.contains("success") ||
            request.url.contains("callback")) {
          _confirmPayment();
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      }));
  }

  Future<void> _confirmPayment() async {
    final service = PaymentService('', token: widget.token);
    try {
      final result = await service.confirmPayment(widget.reference);
      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result?["message"] ?? "Payment verified!")),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context, false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Payment verification failed: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Complete Payment")),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
        ],
      ),
    );
  }
}
