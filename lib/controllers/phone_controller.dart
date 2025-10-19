import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:phone_shop/constants/constants.dart';
import 'package:phone_shop/controllers/base_product_controller.dart';
import 'package:phone_shop/models/phone_model.dart';

class PhoneController extends BaseProductController<PhoneModel> {
  @override
  String get endpoint => '$appBaseUrl/api/phones';

  @override
  PhoneModel fromJson(Map<String, dynamic> json) => PhoneModel.fromJson(json);

  /// Add new phone with image upload
  Future<PhoneModel?> addPhone(PhoneModel phone, List<File> images) async {
    try {
      final uri = Uri.parse(endpoint);
      final request = http.MultipartRequest('POST', uri);

      // Append form fields
      request.fields['brand'] = phone.brand;
      request.fields['model'] = phone.model;
      request.fields['slug'] = phone.slug;
      request.fields['currency'] = phone.currency;
      request.fields['slug'] = phone.slug;
      request.fields['category'] = phone.category.id;
      request.fields['stock'] = phone.stock.toString();

      // Pricing
      request.fields['pricing'] = jsonEncode(phone.pricing.toJson());
      // Specs
      request.fields['specs'] = jsonEncode(phone.specs.toJson());

      // Add images
      for (var file in images) {
        request.files.add(await http.MultipartFile.fromPath(
          'images',
          file.path,
        ));
      }

      final response = await request.send();
      final respStr = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        final jsonResponse = json.decode(respStr);
        return PhoneModel.fromJson(jsonResponse['data']);
      } else {
        Get.snackbar('Error', "${response.statusCode} $respStr");
        return null;
      }
    } catch (e) {
      Get.snackbar("Error adding phone", "$e");
      return null;
    }
  }

  /// Update existing phone (optionally with new images)
  Future<PhoneModel?> updatePhone(String id, PhoneModel phone,
      [List<File>? images]) async {
    try {
      final uri = Uri.parse('$endpoint/update/$id');
      final request = http.MultipartRequest('PUT', uri);

      request.fields['brand'] = phone.brand;
      request.fields['model'] = phone.model;
      request.fields['currency'] = phone.currency;
      request.fields['slug'] = phone.slug;
      request.fields['category'] = phone.category.id;
      request.fields['stock'] = phone.stock.toString();

      request.fields['pricing[purchasePrice]'] =
          phone.pricing.purchasePrice.toString();
      request.fields['pricing[sellingPrice]'] =
          phone.pricing.sellingPrice.toString();

      request.fields['specs'] = jsonEncode(phone.specs.toJson());

      // Optional image upload
      if (images != null && images.isNotEmpty) {
        for (var file in images) {
          request.files.add(await http.MultipartFile.fromPath(
            'images',
            file.path,
          ));
        }
      }

      final response = await request.send();
      final respStr = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(respStr);
        return PhoneModel.fromJson(jsonResponse);
      } else {
        Get.snackbar('Error', "${response.statusCode} $respStr");
        return null;
      }
    } catch (e) {
      Get.snackbar('Error updating phone', "$e");
      return null;
    }
  }

  /// Delete phone by ID
  Future<bool> deletePhone(String id) async {
    try {
      final response = await http.delete(Uri.parse('$endpoint/delete/$id'));
      if (response.statusCode == 200) {
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
