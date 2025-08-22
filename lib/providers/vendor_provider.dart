import 'package:flutter/material.dart';

import '../models/vendor_model.dart';
import '../services/vendor_service.dart';

class VendorProvider extends ChangeNotifier {
  Vendor? _vendor;
  Vendor? get vendor => _vendor;
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Future<void> loadVendorDetails() async {
    _vendor = await VendorService().getVendorDetails();
    _isLoading = false;
    notifyListeners();
  }
}
