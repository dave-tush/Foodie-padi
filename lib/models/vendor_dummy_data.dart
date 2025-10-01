import 'vendor_model.dart';

class VendorDummyData {
  static Vendor getVendorData() {
    return Vendor(
      name: "Relish Treats",
      location: "Ladokun",
      currentOrders: 100,
      specialOrders: 1,
      sales: [
        Sale(time: "10AM", amount: 20),
        Sale(time: "11AM", amount: 25),
        Sale(time: "12PM", amount: 30),
        Sale(time: "01PM", amount: 100),
        Sale(time: "02PM", amount: 23),
        Sale(time: "03PM", amount: 27),
        Sale(time: "04PM", amount: 35),
      ],
      averageRating: 4.9,
      totalReviews: 20,
    );
  }
}
