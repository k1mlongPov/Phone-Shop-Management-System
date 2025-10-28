import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:phone_shop/constants/constants.dart';
import 'package:phone_shop/models/supplier_model.dart';

class SupplierController extends GetxController {
  var isLoading = false.obs;
  var suppliers = <SupplierModel>[].obs;
  var selectedSupplierId = ''.obs;

  /// ✅ Fetch all suppliers
  Future<void> fetchSuppliers() async {
    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse('$appBaseUrl/api/suppliers'));

      if (response.statusCode == 200) {
        suppliers.value = supplierModelFromJson(response.body);
      } else {
        Get.snackbar('Error', 'Failed to fetch suppliers');
      }
    } catch (e) {
      Get.snackbar('Error', 'Unable to load suppliers: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// ✅ Add new supplier
  Future<void> addSupplier(
    String name,
    String contactName,
    String email,
    String phone,
    String address,
  ) async {
    try {
      final res = await http.post(
        Uri.parse('$appBaseUrl/api/suppliers'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'contactName': contactName,
          'email': email,
          'phone': phone,
          'address': address,
        }),
      );

      if (res.statusCode == 201) {
        Get.snackbar('Success', 'Supplier added successfully');
        await fetchSuppliers();
      } else {
        final msg = jsonDecode(res.body)['message'] ?? 'Failed to add supplier';
        Get.snackbar('Error', msg);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to add supplier: $e');
    }
  }

  /// ✅ Update supplier by ID
  Future<bool> updateSupplier({
    required String id,
    required String name,
    required String contactName,
    required String email,
    required String phone,
    required bool active,
  }) async {
    try {
      final res = await http.put(
        Uri.parse('$appBaseUrl/api/suppliers/update/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'contactName': contactName,
          'email': email,
          'phone': phone,
          'active': active,
        }),
      );

      if (res.statusCode == 200) {
        await fetchSuppliers();
        Get.snackbar('Success', 'Supplier updated successfully');
        return true;
      } else {
        final msg =
            jsonDecode(res.body)['message'] ?? 'Failed to update supplier';
        Get.snackbar('Error', msg);
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update supplier: $e');
      return false;
    }
  }

  /// ✅ Delete supplier by ID
  Future<void> deleteSupplier(String id) async {
    try {
      final res =
          await http.delete(Uri.parse('$appBaseUrl/api/suppliers/delete/$id'));

      if (res.statusCode == 200) {
        suppliers.removeWhere((s) => s.id == id);
        Get.snackbar('Deleted', 'Supplier deleted successfully');
      } else {
        final msg =
            jsonDecode(res.body)['message'] ?? 'Failed to delete supplier';
        Get.snackbar('Error', msg);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete supplier: $e');
    }
  }

  /// ✅ Get supplier by ID (for edit form)
  SupplierModel? getById(String id) {
    return suppliers.firstWhereOrNull((s) => s.id == id);
  }
}
