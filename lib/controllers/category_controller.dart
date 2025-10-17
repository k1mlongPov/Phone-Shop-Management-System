import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:phone_shop/constants/constants.dart';
import 'package:phone_shop/models/category_model.dart';
import 'package:phone_shop/models/api_error.dart';

class CategoryController extends GetxController {
  var isLoading = false.obs;
  var categories = <CategoryModel>[].obs;
  var error = Rx<Exception?>(null);
  var apiError = Rx<ApiError?>(null);

  @override
  void onInit() {
    fetchCategories();
    super.onInit();
  }

  Future<void> fetchCategories() async {
    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse('$appBaseUrl/api/categories'));

      if (response.statusCode == 200) {
        categories.value = categoryModelFromJson(response.body);
      } else {
        apiError.value = apiErrorFromJson(response.body);
      }
    } catch (e) {
      error.value = e is Exception ? e : Exception(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
