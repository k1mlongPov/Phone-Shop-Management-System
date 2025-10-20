import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:phone_shop/constants/constants.dart';
import 'package:phone_shop/models/supplier_model.dart';

class SupplierController extends GetxController {
  var suppliers = <SupplierModel>[].obs;
  var isLoading = false.obs;
  var selectedSupplierId = ''.obs;

  final String endpoint = '$appBaseUrl/api/suppliers';

  @override
  void onInit() {
    super.onInit();
    fetchSuppliers();
  }

  Future<void> fetchSuppliers() async {
    try {
      isLoading.value = true;
      final res = await http.get(Uri.parse('$appBaseUrl/api/suppliers'));
      if (res.statusCode == 200) {
        suppliers.assignAll(supplierModelFromJson(res.body));
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load suppliers: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addSupplier(SupplierModel supplier) async {
    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(supplier.toJson()),
      );
      if (response.statusCode == 201) {
        await fetchSuppliers();
        Get.snackbar('Success', 'Supplier added successfully');
        return true;
      } else {
        Get.snackbar('Error', 'Failed to add supplier');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Error adding supplier: $e');
      return false;
    }
  }

  Future<bool> updateSupplier(String id, SupplierModel supplier) async {
    try {
      final response = await http.put(
        Uri.parse('$endpoint/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(supplier.toJson()),
      );

      if (response.statusCode == 200) {
        await fetchSuppliers();
        Get.snackbar('Success', 'Supplier updated successfully');
        return true;
      } else {
        Get.snackbar('Error', 'Failed to update supplier');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Error updating supplier: $e');
      return false;
    }
  }

  Future<bool> deleteSupplier(String id) async {
    try {
      final response = await http.delete(Uri.parse('$endpoint/$id'));
      if (response.statusCode == 200) {
        suppliers.removeWhere((s) => s.id == id);
        Get.snackbar('Success', 'Supplier deleted');
        return true;
      } else {
        Get.snackbar('Error', 'Failed to delete supplier');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Error deleting supplier: $e');
      return false;
    }
  }

  /// ✅ Helper method: get currently selected supplier
  SupplierModel? get selectedSupplier {
    if (selectedSupplierId.value.isEmpty) return null;
    return suppliers.firstWhereOrNull((s) => s.id == selectedSupplierId.value);
  }
}
