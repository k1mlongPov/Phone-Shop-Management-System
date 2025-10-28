import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:phone_shop/constants/constants.dart';
import 'package:phone_shop/controllers/category_controller.dart';
import 'package:phone_shop/controllers/switch_controller.dart';
import 'package:phone_shop/models/category_model.dart';

class SubCategoryController extends GetxController {
  var isLoading = false.obs;

  /// Store subcategories grouped by parent category ID
  var subcategoriesByParent = <String, List<CategoryModel>>{}.obs;

  /// Track currently selected subcategory (used in filters)
  var selectedParentId = ''.obs;

  final categoryController = Get.find<CategoryController>();
  final switchController = Get.find<SwitchController>();

  @override
  void onInit() {
    super.onInit();

    ever(categoryController.isLoading, (loading) async {
      if (!loading && categoryController.categories.isNotEmpty) {
        // ✅ Preload both phone & accessory subcategories once
        await fetchInitialSubcategories();
      }
    });
  }

  Future<void> fetchInitialSubcategories() async {
    if (categoryController.categories.isEmpty) return;

    final phoneParent = categoryController.categories.firstWhereOrNull(
      (c) => c.name.toLowerCase().contains('phone'),
    );
    final accessoryParent = categoryController.categories.firstWhereOrNull(
      (c) => c.name.toLowerCase().contains('accessory'),
    );

    if (phoneParent != null) {
      await fetchSubcategories(phoneParent.id);
    }
    if (accessoryParent != null) {
      await fetchSubcategories(accessoryParent.id);
    }
  }

  /// ✅ Automatically fetch based on switch toggle (Phone / Accessory)
  Future<void> fetchBasedOnSwitch() async {
    if (categoryController.categories.isEmpty) return;

    final isPhoneMode = switchController.isSwitch.value;

    final parent = isPhoneMode
        ? categoryController.categories.firstWhereOrNull(
            (c) => c.name.toLowerCase().contains('phone'),
          )
        : categoryController.categories.firstWhereOrNull(
            (c) => c.name.toLowerCase().contains('accessory'),
          );

    if (parent == null) return;

    subcategoriesByParent.clear();
    subcategoriesByParent.refresh();

    isLoading.value = true;

    // 🔄 Fetch subcategories
    await fetchSubcategories(parent.id, force: true);

    // ✅ Set active parent *after* fetch success
    selectedParentId.value = parent.id;

    isLoading.value = false;
  }

  Future<void> fetchSubcategories(String parentId, {bool force = false}) async {
    if (!force && subcategoriesByParent.containsKey(parentId)) {
      // Already loaded — skip unless forced
      return;
    }

    isLoading.value = true;
    try {
      final res = await http.get(
        Uri.parse('$appBaseUrl/api/categories/$parentId/subcategories'),
      );

      if (res.statusCode == 200) {
        final data = categoryModelFromJson(res.body);

        final withAllOption = [
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

        subcategoriesByParent[parentId] = withAllOption;
        subcategoriesByParent.refresh();
      } else {
        Get.snackbar('Error', 'Failed to load subcategories');
        subcategoriesByParent[parentId] = [];
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch subcategories: $e');
      subcategoriesByParent[parentId] = [];
    } finally {
      isLoading.value = false;
    }
  }

  /// ✅ Force refresh specific parent (ignore cache)
  Future<void> refetchSubcategories(String parentId) async {
    subcategoriesByParent.remove(parentId); // clear old cache
    await fetchSubcategories(parentId, force: true);
  }

  /// ✅ Fetch manually for specific type (e.g. "phone" or "accessory")
  Future<void> fetchForType(String type, {bool force = false}) async {
    final parent = categoryController.categories.firstWhereOrNull(
      (c) => c.name.toLowerCase().contains(type.toLowerCase()),
    );

    if (parent != null) {
      if (force || !subcategoriesByParent.containsKey(parent.id)) {
        await fetchSubcategories(parent.id, force: force);
      }
    }
  }

  /// ✅ Add new subcategory
  Future<bool> addSubcategory(String parentId, String name) async {
    try {
      final response = await http.post(
        Uri.parse('$appBaseUrl/api/categories'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'parent': parentId}),
      );

      if (response.statusCode == 201) {
        Get.snackbar('Success', 'Subcategory added successfully');
        Future.delayed(const Duration(milliseconds: 100), () {
          refetchSubcategories(parentId);
        });
        return true;
      } else {
        Get.snackbar('Error', 'Failed to add subcategory');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Add subcategory failed: $e');
      return false;
    }
  }

  Future<bool> updateSubcategory(String id, String name) async {
    try {
      final response = await http.put(
        Uri.parse('$appBaseUrl/api/categories/update/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name}),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Subcategory updated successfully');
        // Refetch all parents — optional optimization: only parent containing this id
        final parentKeys = List<String>.from(subcategoriesByParent.keys);
        for (final key in parentKeys) {
          await refetchSubcategories(key);
        }
        return true;
      } else {
        Get.snackbar('Error', 'Failed to update subcategory');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Update subcategory failed: $e');
      return false;
    }
  }

  /// ✅ Delete subcategory
  Future<void> deleteSubcategory(String id) async {
    try {
      final response =
          await http.delete(Uri.parse('$appBaseUrl/api/categories/delete/$id'));
      if (response.statusCode == 200) {
        // Remove from all cached lists
        subcategoriesByParent.forEach((key, list) {
          list.removeWhere((s) => s.id == id);
        });
        subcategoriesByParent.refresh();

        Get.snackbar('Deleted', 'Subcategory deleted successfully');
      } else {
        Get.snackbar('Error', 'Failed to delete subcategory');
      }
    } catch (e) {
      Get.snackbar('Error', 'Delete subcategory failed: $e');
    }
  }

  /// ✅ Helper to get subcategories for a parent safely
  List<CategoryModel> getSubcategories(String parentId) {
    return subcategoriesByParent[parentId] ?? [];
  }

  @override
  void onClose() {
    subcategoriesByParent.clear();
    super.onClose();
  }
}
