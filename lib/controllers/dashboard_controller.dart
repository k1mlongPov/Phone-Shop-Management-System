import 'package:get/get.dart';

class DashboardController extends GetxController {
  var totalPhones = 0.obs;
  var totalAccessories = 0.obs;
  var totalCategories = 0.obs;
  var totalProfit = 0.0.obs;

  var lowStockItems = <Map<String, dynamic>>[].obs;
  var monthlyPhoneProfit = <Map<String, dynamic>>[].obs;
  var monthlyAccessoryProfit = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
    loadMonthlyProfit();
  }

  // 🧠 Later connect to your Node.js API here
  Future<void> loadDashboardData() async {
    // Mock data for now
    await Future.delayed(const Duration(milliseconds: 800));
    totalPhones.value = 28;
    totalAccessories.value = 14;
    totalCategories.value = 7;
    totalProfit.value = 1350.75;

    lowStockItems.value = [
      {'name': 'iPhone 15 Pro', 'stock': 3},
      {'name': 'Oppo A18', 'stock': 2},
      {'name': '65W Fast Charger', 'stock': 4},
    ];
  }

  void loadMonthlyProfit() {
    // Mock data (replace with API later)
    monthlyPhoneProfit.value = [
      {'month': 'Jan', 'profit': 450.0},
      {'month': 'Feb', 'profit': 700.0},
      {'month': 'Mar', 'profit': 950.0},
      {'month': 'Apr', 'profit': 850.0},
      {'month': 'May', 'profit': 1100.0},
      {'month': 'Jun', 'profit': 1250.0},
      {'month': 'Jul', 'profit': 980.0},
      {'month': 'Aug', 'profit': 1200.0},
      {'month': 'Sep', 'profit': 1020.0},
      {'month': 'Oct', 'profit': 1350.0},
    ];

    monthlyAccessoryProfit.value = [
      {'month': 'Jan', 'profit': 200.0},
      {'month': 'Feb', 'profit': 300.0},
      {'month': 'Mar', 'profit': 400.0},
      {'month': 'Apr', 'profit': 500.0},
      {'month': 'May', 'profit': 600.0},
      {'month': 'Jun', 'profit': 700.0},
      {'month': 'Jul', 'profit': 650.0},
      {'month': 'Aug', 'profit': 720.0},
      {'month': 'Sep', 'profit': 680.0},
      {'month': 'Oct', 'profit': 750.0},
    ];
  }
}
