import '../models/vendor_dummy_data.dart';
import '../models/vendor_model.dart';

class VendorService {
  Future<Vendor> getVendorDetails() async {
    await Future.delayed(Duration(seconds: 2));
    return VendorDummyData.getVendorData();
  }
}
