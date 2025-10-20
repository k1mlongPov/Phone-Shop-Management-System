import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:phone_shop/constants/constants.dart';
import 'package:phone_shop/controllers/base_product_controller.dart';
import 'package:phone_shop/controllers/supplier_controller.dart';
import 'package:phone_shop/models/phone_model.dart';
import 'package:phone_shop/models/specs_model.dart';

class PhoneController extends BaseProductController<PhoneModel> {
  @override
  String get endpoint => '$appBaseUrl/api/phones';

  @override
  PhoneModel fromJson(Map<String, dynamic> json) => PhoneModel.fromJson(json);

  final supplierController = Get.put(SupplierController());

  /// Add new phone with image upload
  Future<void> addPhone({
    required String brand,
    required String model,
    required String slug,
    required double purchasePrice,
    required double sellingPrice,
    required SpecsModel specs,
    String? categoryId,
    String? supplierId,
    required int stock,
    List<File>? images,
  }) async {
    final uri = Uri.parse(endpoint);
    final request = http.MultipartRequest('POST', uri);

    // Basic info
    request.fields['brand'] = brand;
    request.fields['model'] = model;
    request.fields['slug'] = slug;

    // Nested fields for pricing
    request.fields['pricing[purchasePrice]'] = purchasePrice.toString();
    request.fields['pricing[sellingPrice]'] = sellingPrice.toString();

    // Category & supplier
    if (categoryId != null && categoryId.isNotEmpty) {
      request.fields['category'] = categoryId;
    }
    if (supplierId != null && supplierId.isNotEmpty) {
      request.fields['supplier'] = supplierId;
    }

    request.fields['stock'] = stock.toString();

    // Nested specs
    final specsJson = specs.toJson();
    specsJson.forEach((key, value) {
      if (value != null) {
        if (value is Map) {
          value.forEach((subKey, subValue) {
            if (subValue != null) {
              request.fields['specs[$key][$subKey]'] = subValue.toString();
            }
          });
        } else if (value is List) {
          for (int i = 0; i < value.length; i++) {
            request.fields['specs[$key][$i]'] = value[i].toString();
          }
        } else {
          request.fields['specs[$key]'] = value.toString();
        }
      }
    });

    // Images
    if (images != null && images.isNotEmpty) {
      for (var file in images) {
        request.files
            .add(await http.MultipartFile.fromPath('images', file.path));
      }
    }

    final response = await request.send();
    final body = await response.stream.bytesToString();

    if (response.statusCode == 201) {
      Get.snackbar('Success', 'Phone added successfully');
      await refetch();
    } else {
      Get.snackbar('Error', jsonDecode(body)['message'] ?? 'Failed');
    }
  }

  /// Update existing phone (optionally with new images)
  Future<PhoneModel?> updatePhone(String id, PhoneModel phone,
      [List<File>? images]) async {
    try {
      final uri = Uri.parse('$endpoint/update/$id');
      final request = http.MultipartRequest('PUT', uri);

      // Basic fields
      request.fields['brand'] = phone.brand;
      request.fields['model'] = phone.model;
      request.fields['slug'] = phone.slug;
      request.fields['currency'] = phone.currency;
      request.fields['category'] = phone.category.id;
      request.fields['supplier'] = phone.supplier!.id;
      request.fields['stock'] = phone.stock.toString();

      // Pricing
      request.fields['pricing[purchasePrice]'] =
          phone.pricing.purchasePrice.toString();
      request.fields['pricing[sellingPrice]'] =
          phone.pricing.sellingPrice.toString();

      // Specs (nested)
      final specsJson = phone.specs.toJson();
      specsJson.forEach((key, value) {
        if (value != null) {
          if (value is Map) {
            value.forEach((subKey, subValue) {
              if (subValue != null) {
                request.fields['specs[$key][$subKey]'] = subValue.toString();
              }
            });
          } else if (value is List) {
            for (int i = 0; i < value.length; i++) {
              request.fields['specs[$key][$i]'] = value[i].toString();
            }
          } else {
            request.fields['specs[$key]'] = value.toString();
          }
        }
      });

      // Images
      if (images != null && images.isNotEmpty) {
        for (var file in images) {
          request.files
              .add(await http.MultipartFile.fromPath('images', file.path));
        }
      }

      final response = await request.send();
      final respStr = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(respStr);
        final updatedPhone = PhoneModel.fromJson(jsonResponse);
        Get.snackbar('Success', 'Phone updated successfully');
        await refetch();
        return updatedPhone;
      } else {
        Get.snackbar('Error', "Failed: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      Get.snackbar('Error', 'Update failed: $e');
      return null;
    }
  }

  /// Delete phone by ID
  Future<bool> deletePhone(String id) async {
    try {
      final response = await http.delete(Uri.parse('$endpoint/delete/$id'));
      if (response.statusCode == 200) {
        items.removeWhere((item) => (item as dynamic).id == id);
        Future.microtask(() => refetch());
        return true;
      } else {
        Get.snackbar('Failed to delete phone', "${response.statusCode}");
        return false;
      }
    } catch (e) {
      Get.snackbar('Error to delete phone', "$e");
      return false;
    }
  }
}
