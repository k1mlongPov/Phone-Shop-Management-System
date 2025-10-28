import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:phone_shop/constants/constants.dart';
import 'package:phone_shop/controllers/base_product_controller.dart';
import 'package:phone_shop/models/accessory_model.dart';

class AccessoryController extends BaseProductController<AccessoryModel> {
  @override
  String get endpoint => '$appBaseUrl/api/accessories';

  @override
  AccessoryModel fromJson(Map<String, dynamic> json) =>
      AccessoryModel.fromJson(json);

  /// Add a new accessory
  Future<void> addAccessory({
    required String name,
    required String type,
    String? brand,
    required double purchasePrice,
    required double sellingPrice,
    String? categoryId,
    String? supplierId,
    String? sku,
    int? stock,
    int? lowStockThreshold,
    String? currency,
    Map<String, dynamic>? attributes,
    List<String>? compatibility,
    List<File>? images,
  }) async {
    final uri = Uri.parse(endpoint);
    final request = http.MultipartRequest('POST', uri);

    request.fields['name'] = name;
    request.fields['type'] = type;
    if (brand != null) request.fields['brand'] = brand;
    if (sku != null) request.fields['sku'] = sku;
    if (currency != null) request.fields['currency'] = currency;

    request.fields['pricing[purchasePrice]'] = purchasePrice.toString();
    request.fields['pricing[sellingPrice]'] = sellingPrice.toString();

    if (categoryId != null && categoryId.isNotEmpty) {
      request.fields['category'] = categoryId;
    }
    if (supplierId != null && supplierId.isNotEmpty) {
      request.fields['supplier'] = supplierId;
    }

    request.fields['stock'] = (stock ?? 0).toString();
    request.fields['lowStockThreshold'] = (lowStockThreshold ?? 10).toString();

    // Attributes
    if (attributes != null && attributes.isNotEmpty) {
      attributes.forEach((key, value) {
        if (value is Map) {
          value.forEach((subKey, subValue) {
            request.fields['attributes[$key][$subKey]'] = subValue.toString();
          });
        } else {
          request.fields['attributes[$key]'] = value.toString();
        }
      });
    }

    // Compatibility
    if (compatibility != null && compatibility.isNotEmpty) {
      for (int i = 0; i < compatibility.length; i++) {
        request.fields['compatibility[$i]'] = compatibility[i];
      }
    }

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
      Get.snackbar('Success', 'Accessory added successfully');
      await refetch();
    } else {
      Get.snackbar('Error', jsonDecode(body)['message'] ?? 'Failed');
    }
  }

  /// Update accessory
  Future<AccessoryModel?> updateAccessory(String id, AccessoryModel item,
      [List<File>? images]) async {
    try {
      final uri = Uri.parse('$endpoint/update/$id');
      final request = http.MultipartRequest('PUT', uri);

      request.fields['name'] = item.name;
      request.fields['type'] = item.type;
      if (item.brand != null) request.fields['brand'] = item.brand!;
      request.fields['currency'] = item.currency;
      request.fields['stock'] = item.stock.toString();
      request.fields['lowStockThreshold'] = item.lowStockThreshold.toString();
      if (item.category != null) {
        request.fields['category'] = item.category!.id;
      }
      if (item.supplier != null) {
        request.fields['supplier'] = item.supplier!.id;
      }

      // Pricing
      request.fields['pricing[purchasePrice]'] =
          item.pricing.purchasePrice.toString();
      request.fields['pricing[sellingPrice]'] =
          item.pricing.sellingPrice.toString();

      // Attributes
      if (item.attributes != null) {
        item.attributes!.forEach((key, value) {
          if (value is Map) {
            value.forEach((subKey, subValue) {
              request.fields['attributes[$key][$subKey]'] = subValue.toString();
            });
          } else {
            request.fields['attributes[$key]'] = value.toString();
          }
        });
      }

      // Compatibility
      if (item.compatibility != null && item.compatibility!.isNotEmpty) {
        for (int i = 0; i < item.compatibility!.length; i++) {
          request.fields['compatibility[$i]'] = item.compatibility![i];
        }
      }

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
        final updated = AccessoryModel.fromJson(jsonResponse['data']);
        Get.snackbar('Success', 'Accessory updated successfully');
        await refetch();
        return updated;
      } else {
        Get.snackbar('Error', 'Failed to update accessory');
        return null;
      }
    } catch (e) {
      Get.snackbar('Error', 'Update failed: $e');
      return null;
    }
  }

  /// Delete accessory
  Future<bool> deleteAccessory(String id) async {
    try {
      final response = await http.delete(Uri.parse('$endpoint/delete/$id'));
      if (response.statusCode == 200) {
        items.removeWhere((item) => (item as dynamic).id == id);
        Future.microtask(() => refetch());
        return true;
      } else {
        Get.snackbar('Error', 'Failed to delete accessory');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Delete failed: $e');
      return false;
    }
  }
}
