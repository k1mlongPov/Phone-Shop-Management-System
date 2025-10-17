import 'package:get/get.dart';
import 'package:phone_shop/constants/constants.dart';
import 'package:phone_shop/controllers/category_controller.dart';
import 'package:phone_shop/controllers/switch_controller.dart';
import 'package:phone_shop/models/category_model.dart';
import 'package:http/http.dart' as http;

class SubCategoryController extends GetxController {
  var isLoading = false.obs;
  var subCategories = <CategoryModel>[].obs;
  var selectedParentId = ''.obs;

  final categoryController = Get.find<CategoryController>();
  final switchController = Get.find<SwitchController>();

  @override
  void onInit() {
    super.onInit();

    // Wait for categories to load, then fetch correct subcategories
    ever(categoryController.isLoading, (loading) {
      if (loading == false && categoryController.categories.isNotEmpty) {
        fetchBasedOnSwitch();
      }
    });

    // Re-fetch when Phones/Accessories toggle changes
    ever(switchController.isSwitch, (_) => fetchBasedOnSwitch());
  }

  Future<void> fetchBasedOnSwitch() async {
    if (categoryController.categories.isEmpty) return;

    final parent = switchController.isSwitch.value
        ? categoryController.categories.firstWhereOrNull(
            (c) => c.name.toLowerCase().contains('phone'),
          )
        : categoryController.categories.firstWhereOrNull(
            (c) => c.name.toLowerCase().contains('accessory'),
          );

    if (parent == null) return;
    await fetchSubcategories(parent.id);
  }

  Future<void> fetchSubcategories(String parentId) async {
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse('$appBaseUrl/api/categories/$parentId/subcategories'),
      );

      if (response.statusCode == 200) {
        final data = categoryModelFromJson(response.body);
        subCategories.value = [
          CategoryModel(
            id: '',
            name: 'All',
            description: '',
            image: '',
            parent: null,
            isActive: true,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          ...data,
        ];

        // keep previous selection if valid
        if (!subCategories.any((e) => e.id == selectedParentId.value)) {
          selectedParentId.value = '';
        }
      }
    } finally {
      isLoading.value = false;
    }
  }
}
