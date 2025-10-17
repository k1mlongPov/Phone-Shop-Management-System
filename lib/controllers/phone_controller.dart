import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:phone_shop/constants/constants.dart';
import 'package:phone_shop/models/phone_model.dart';
import 'package:phone_shop/controllers/subcategory_controller.dart';

class PhoneController extends GetxController {
  var isLoading = false.obs;
  var products = <PhoneModel>[].obs;
  var selectedSubcategoryId = ''.obs;

  final subCategoryController = Get.find<SubCategoryController>();

  @override
  void onInit() {
    super.onInit();

    //  Fetch all products when page loads
    fetchProducts('');

    // Re-fetch whenever subcategory changes
    ever(subCategoryController.selectedParentId, (String subId) {
      fetchProducts(subId.isEmpty ? '' : subId);
    });
  }

  Future<void> fetchProducts(String subcategoryId) async {
    isLoading.value = true;
    try {
      final Uri url = subcategoryId.isEmpty
          ? Uri.parse('$appBaseUrl/api/phones')
          : Uri.parse('$appBaseUrl/api/phones?category=$subcategoryId');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List<dynamic> data = decoded['data'] ?? [];
        products.value =
            List<PhoneModel>.from(data.map((e) => PhoneModel.fromJson(e)));
      } else {
        products.clear();
        debugPrintStack();
      }
    } catch (e) {
      e.printError();
      products.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void selectSubcategory(String subcategoryId) {
    selectedSubcategoryId.value = subcategoryId;
    fetchProducts(subcategoryId.isEmpty ? '' : subcategoryId);
  }
}
