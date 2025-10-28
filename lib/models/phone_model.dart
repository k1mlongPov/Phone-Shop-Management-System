import 'dart:convert';
import 'package:phone_shop/models/category_model.dart';
import 'package:phone_shop/models/pricing_model.dart';
import 'package:phone_shop/models/specs_model.dart';
import 'package:phone_shop/models/supplier_model.dart';
import 'package:phone_shop/models/variant_form_data.dart';

List<PhoneModel> phoneModelFromJson(String str) => List<PhoneModel>.from(
    json.decode(str)["data"].map((x) => PhoneModel.fromJson(x)));

String phoneModelToJson(List<PhoneModel> data) =>
    json.encode({"data": List<dynamic>.from(data.map((x) => x.toJson()))});

class PhoneModel {
  final String id;
  final String brand;
  final String model;
  final String slug;
  final String currency;
  final Pricing pricing;
  final SpecsModel specs;
  final CategoryModel category;
  final SupplierModel? supplier;
  final List<String> images;
  final int stock;
  final bool isActive;
  final int lowStockThreshold;
  final double? batteryHealth;
  final List<VariantFormData> variants;

  PhoneModel({
    required this.id,
    required this.brand,
    required this.model,
    required this.slug,
    required this.currency,
    required this.pricing,
    required this.specs,
    required this.category,
    this.supplier,
    required this.images,
    required this.stock,
    required this.isActive,
    required this.lowStockThreshold,
    this.batteryHealth,
    required this.variants,
  });

  factory PhoneModel.fromJson(Map<String, dynamic> json) => PhoneModel(
        id: json['_id'] ?? '',
        brand: json['brand'] ?? '',
        model: json['model'] ?? '',
        slug: json['slug'] ?? '',
        currency: json['currency'] ?? 'USD',
        pricing: Pricing.fromJson(json['pricing'] ?? {}),
        specs: SpecsModel.fromJson(json['specs'] ?? {}),
        category: CategoryModel.fromJson(json['category'] ?? {}),
        supplier: json['supplier'] != null &&
                json['supplier'] is Map<String, dynamic> &&
                json['supplier'].isNotEmpty
            ? SupplierModel.fromJson(json['supplier'])
            : null,
        images: List<String>.from(json['images'] ?? []),
        stock: json['stock'] ?? 0,
        isActive: json['isActive'] ?? true,
        lowStockThreshold: json['lowStockThreshold'] ?? 5,
        batteryHealth: (json['specs']?['batteryHealth'] ?? 0).toDouble(),
        variants: json['variants'] != null
            ? List<VariantFormData>.from((json['variants'] as List)
                .map((v) => VariantFormData.fromJson(v)))
            : [],
      );

  // ✅ To JSON (for update)
  Map<String, dynamic> toJson() => {
        "_id": id,
        "brand": brand,
        "model": model,
        "slug": slug,
        "currency": currency,
        "pricing": pricing.toJson(),
        "specs": specs.toJson(),
        "category": category.toJson(),
        "supplier": supplier?.toJson(),
        "images": List<dynamic>.from(images.map((x) => x)),
        "stock": stock,
        "isActive": isActive,
        "lowStockThreshold": lowStockThreshold,
        "variants": variants.map((v) => v.toJson()).toList(),
      };
}
