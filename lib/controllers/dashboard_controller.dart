import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:phone_shop/constants/constants.dart';
import 'package:phone_shop/models/accessory_model.dart';
import 'package:phone_shop/models/category_model.dart';
import 'package:phone_shop/models/phone_model.dart';

class DashboardController extends GetxController {
  var isLoading = false.obs;
  var totalPhones = 0.obs;
  var totalAccessories = 0.obs;
  var totalSubCategories = 0.obs;
  var totalPurchaseValue = 0.0.obs;

  var monthlyPhoneProfit = <Map<String, dynamic>>[].obs;
  var monthlyAccessoryProfit = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
    loadMonthlyProfit();
  }

  Future<void> fetchDashboardData() async {
    isLoading.value = true;
    try {
      // Fetch phones
      final phoneRes = await http.get(Uri.parse('$appBaseUrl/api/phones'));
      if (phoneRes.statusCode == 200) {
        final decoded = jsonDecode(phoneRes.body);
        final List<dynamic> phoneData = decoded['data'] ?? [];
        final phones =
            List<PhoneModel>.from(phoneData.map((e) => PhoneModel.fromJson(e)));
        totalPhones.value = phones.length;

        // Add up total purchasePrice for phones
        final phonePurchaseTotal = phones.fold<double>(
          0.0,
          (sum, phone) => sum + phone.pricing.purchasePrice,
        );
        totalPurchaseValue.value += phonePurchaseTotal;
      }

      // Fetch accessories
      final accRes = await http.get(Uri.parse('$appBaseUrl/api/accessories'));
      if (accRes.statusCode == 200) {
        final decoded = jsonDecode(accRes.body);
        final List<dynamic> accData = decoded['data'] ?? [];
        final accessories = List<AccessoryModel>.from(
            accData.map((e) => AccessoryModel.fromJson(e)));
        totalAccessories.value = accessories.length;

        // Add up total purchasePrice for accessories
        final accPurchaseTotal = accessories.fold<double>(
          0.0,
          (sum, acc) => sum + acc.pricing.purchasePrice,
        );
        totalPurchaseValue.value += accPurchaseTotal;
      }

      // Fetch categories
      final res =
          await http.get(Uri.parse('$appBaseUrl/api/categories/subcategories'));

      if (res.statusCode == 200) {
        final List<CategoryModel> subcategories =
            categoryModelFromJson(res.body);
        totalSubCategories.value = subcategories.length;
      }
    } catch (e) {
      debugPrintStack();
    } finally {
      isLoading.value = false;
    }
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
