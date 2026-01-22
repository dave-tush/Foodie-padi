import 'package:flutter/material.dart';
import 'package:foodie_padi_apps/core/constants/api_constants.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:foodie_padi_apps/services/payment_service.dart';
import 'package:foodie_padi_apps/screens/homescreen/homepage_screen.dart';

class PaymentWebviewScreen extends StatefulWidget {
  final String paymentUrl;
  final String reference;
  final String token;

  const PaymentWebviewScreen({
    super.key,
    required this.paymentUrl,
    required this.reference,
    required this.token,
  });

  @override
  State<PaymentWebviewScreen> createState() => _PaymentWebviewScreenState();
}

class _PaymentWebviewScreenState extends State<PaymentWebviewScreen> {
  late final WebViewController _controller;

  bool isLoading = true;
  bool isVerifying = false;
  bool verificationStarted = false;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: _handleNavigation,
          onPageStarted: (_) => setState(() => isLoading = true),
          onPageFinished: (_) => setState(() => isLoading = false),
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  NavigationDecision _handleNavigation(NavigationRequest request) {
    final url = request.url.toLowerCase();

    /// Paystack redirects to callback URL after payment
    if (url.contains('callback') || url.contains('payment-success')) {
      if (!verificationStarted) {
        verificationStarted = true;
        _verifyPayment();
      }
      return NavigationDecision.prevent;
    }

    return NavigationDecision.navigate;
  }

  Future<void> _verifyPayment() async {
    if (isVerifying) return;

    setState(() => isVerifying = true);

    final paymentService = PaymentService(
      ApiConstants.baseUrl,
      token: widget.token,
    );

    const maxRetries = 6;
    int attempt = 0;

    while (attempt < maxRetries) {
      try {
        final response = await paymentService.confirmPayment(widget.reference);
        print('Payment response: $response');
        final status = response?['data']?['status'] ?? response?['status'];
        print('Payment status: $status');

        if (status == 'success' || status == 'Payment already confirmed') {
          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Payment successful')),
          );

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
            (_) => false,
          );
          return;
        }
      } catch (_) {}

      attempt++;
      await Future.delayed(const Duration(seconds: 2));
    }

    if (!mounted) return;
    setState(() => isVerifying = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Payment verification failed. Contact support if debited.',
        ),
      ),
    );
  }

  Future<void> _confirmExit() async {
    if (isVerifying) return;

    final exit = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cancel payment?'),
        content: const Text(
          'If you already paid, verification may still be in progress.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Stay'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Exit'),
          ),
        ],
      ),
    );

    if (exit == true && mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Complete Payment'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: _confirmExit,
          ),
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (isLoading) const Center(child: CircularProgressIndicator()),
            if (isVerifying)
              Container(
                color: Colors.black45,
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 12),
                      Text(
                        'Verifying payment...',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),

        /// fallback only
        floatingActionButton: FloatingActionButton.extended(
          onPressed: isLoading || isVerifying ? null : _verifyPayment,
          label: const Text('I have completed payment'),
          icon: const Icon(Icons.check),
        ),
      ),
    );
  }
}
