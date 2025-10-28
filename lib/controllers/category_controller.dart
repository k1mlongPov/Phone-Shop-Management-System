import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:phone_shop/constants/constants.dart';
import 'package:phone_shop/models/category_model.dart';

class CategoryController extends GetxController {
  var categories = <CategoryModel>[].obs;
  var isLoading = false.obs;

  String get endpoint => '$appBaseUrl/api/categories';

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      final response = await http.get(Uri.parse(endpoint));
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        categories.value =
            data.map((json) => CategoryModel.fromJson(json)).toList();
      } else {
        Get.snackbar('Error', 'Failed to load categories');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch categories: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
