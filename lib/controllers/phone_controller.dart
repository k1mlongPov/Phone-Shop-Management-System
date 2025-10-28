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

  Future<bool> addPhone({
    required String brand,
    required String model,
    required String slug,
    required double purchasePrice,
    required double sellingPrice,
    required SpecsModel specs,
    String? categoryId,
    String? supplierId,
    required int stock,
    required int lowStockThreshold,
    double? batteryHealth,
    List<Map<String, dynamic>>? variants,
    List<File>? images,
  }) async {
    final uri = Uri.parse(endpoint);
    final request = http.MultipartRequest('POST', uri);

    request.fields['brand'] = brand;
    request.fields['model'] = model;
    request.fields['slug'] = slug;

    request.fields['pricing[purchasePrice]'] = purchasePrice.toString();
    request.fields['pricing[sellingPrice]'] = sellingPrice.toString();

    if (categoryId != null && categoryId.isNotEmpty) {
      request.fields['category'] = categoryId;
    }
    if (supplierId != null && supplierId.isNotEmpty) {
      request.fields['supplier'] = supplierId;
    }

    request.fields['stock'] = stock.toString();
    request.fields['lowStockThreshold'] = lowStockThreshold.toString();

    final specsJson = specs.toJson();

    // Add batteryHealth explicitly (in case it's not inside SpecsModel)
    if (batteryHealth != null) {
      request.fields['specs[batteryHealth]'] = batteryHealth.toString();
    }

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

    if (variants != null && variants.isNotEmpty) {
      for (int i = 0; i < variants.length; i++) {
        final variant = variants[i];
        if (variant['storage'] != null) {
          request.fields['variants[$i][storage]'] =
              variant['storage'].toString();
        }
        if (variant['color'] != null) {
          request.fields['variants[$i][color]'] = variant['color'].toString();
        }
        if (variant['pricing'] != null) {
          final pricing = variant['pricing'];
          if (pricing['purchasePrice'] != null) {
            request.fields['variants[$i][pricing][purchasePrice]'] =
                pricing['purchasePrice'].toString();
          }
          if (pricing['sellingPrice'] != null) {
            request.fields['variants[$i][pricing][sellingPrice]'] =
                pricing['sellingPrice'].toString();
          }
        }
        if (variant['stock'] != null) {
          request.fields['variants[$i][stock]'] = variant['stock'].toString();
        }
        if (variant['sku'] != null) {
          request.fields['variants[$i][sku]'] = variant['sku'].toString();
        }
      }
    }

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
      return true;
    } else {
      Get.snackbar(
          'Error', jsonDecode(body)['message'] ?? 'Failed to add phone');
      return false;
    }
  }

  Future<PhoneModel?> updatePhone(
    String id,
    PhoneModel phone, [
    List<File>? images,
  ]) async {
    try {
      final uri = Uri.parse('$endpoint/update/$id');
      final request = http.MultipartRequest('PUT', uri);

      // 🔹 Basic fields
      request.fields['brand'] = phone.brand;
      request.fields['model'] = phone.model;
      if (phone.slug.isNotEmpty) {
        request.fields['slug'] = phone.slug;
      }
      request.fields['currency'] = phone.currency;
      request.fields['category'] = phone.category.id;
      request.fields['stock'] = phone.stock.toString();
      request.fields['lowStockThreshold'] = phone.lowStockThreshold.toString();

      if (phone.supplier != null) {
        request.fields['supplier'] = phone.supplier!.id;
      }

      // 🔹 Pricing
      request.fields['pricing[purchasePrice]'] =
          phone.pricing.purchasePrice.toString();
      request.fields['pricing[sellingPrice]'] =
          phone.pricing.sellingPrice.toString();

      // 🔹 Specs
      final specsJson = phone.specs.toJson();
      specsJson.forEach((key, value) {
        if (value != null) {
          request.fields['specs[$key]'] = value.toString();
        }
      });

      if (phone.batteryHealth != null) {
        request.fields['specs[batteryHealth]'] =
            phone.batteryHealth!.toString();
      }

      // 🔹 Variants
      if (phone.variants.isNotEmpty) {
        for (int i = 0; i < phone.variants.length; i++) {
          final variant = phone.variants[i];
          if (variant.color != null && variant.color!.isNotEmpty) {
            request.fields['variants[$i][color]'] = variant.color!;
          }
          request.fields['variants[$i][pricing][purchasePrice]'] =
              variant.pricing.purchasePrice.toString();
          request.fields['variants[$i][pricing][sellingPrice]'] =
              variant.pricing.sellingPrice.toString();
          request.fields['variants[$i][stock]'] = variant.stock.toString();
          request.fields['variants[$i][storage]'] = variant.storage;
        }
      } else {
        request.fields['variants'] = '[]';
      }

      // 🔹 Add images (new + existing)
      if (images != null && images.isNotEmpty) {
        for (var file in images) {
          request.files
              .add(await http.MultipartFile.fromPath('images', file.path));
        }
      } else {
        // send existing images to backend
        for (int i = 0; i < phone.images.length; i++) {
          request.fields['existingImages[$i]'] = phone.images[i];
        }
      }

      // 🔹 Send request
      final response = await request.send();
      final respStr = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(respStr);
        final updatedPhone = PhoneModel.fromJson(jsonResponse);
        Get.snackbar('✅ Success', 'Phone updated successfully');
        await refetch();
        return updatedPhone;
      } else {
        Get.snackbar('⚠️ Error', "Failed: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      Get.snackbar('Error', 'Update failed: $e');
      return null;
    }
  }

  Future<bool> deletePhone(String id) async {
    final response = await http.delete(Uri.parse('$endpoint/delete/$id'));
    if (response.statusCode == 200) {
      items.removeWhere((item) => (item as dynamic).id == id);
      Future.microtask(() => refetch());
      return true;
    } else {
      Get.snackbar('Failed to delete phone', "${response.statusCode}");
      return false;
    }
  }
}
