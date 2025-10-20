import 'dart:convert';
import 'package:phone_shop/models/specs_model.dart';
import 'package:phone_shop/models/supplier_model.dart';

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
  final Category category;
  final SupplierModel? supplier;
  final List<String> images;
  final int stock;
  final bool isActive;

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
  });

  factory PhoneModel.fromJson(Map<String, dynamic> json) => PhoneModel(
        id: json['_id'] ?? '',
        brand: json['brand'] ?? '',
        model: json['model'] ?? '',
        slug: json['slug'] ?? '',
        currency: json['currency'] ?? '',
        pricing: Pricing.fromJson(json['pricing'] ?? {}),
        specs: SpecsModel.fromJson(json['specs'] ?? {}),
        category: Category.fromJson(json['category'] ?? {}),
        supplier: json['supplier'] != null &&
                json['supplier'] is Map<String, dynamic> &&
                json['supplier'].isNotEmpty
            ? SupplierModel.fromJson(json['supplier'])
            : null,
        images: List<String>.from(json['images'] ?? []),
        stock: json['stock'] ?? 0,
        isActive: json['isActive'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "brand": brand,
        "model": model,
        "slug": slug,
        "currency": currency,
        "pricing": pricing.toJson(),
        "specs": specs.toJson(),
        "category": category.toJson(),
        if (supplier != null)
          "supplier": supplier!.toJson(), // ✅ only include if not null
        "images": List<dynamic>.from(images.map((x) => x)),
        "stock": stock,
        "isActive": isActive,
      };
}

class Pricing {
  final double purchasePrice;
  final double sellingPrice;

  Pricing({
    required this.purchasePrice,
    required this.sellingPrice,
  });

  factory Pricing.fromJson(Map<String, dynamic> json) => Pricing(
        purchasePrice: (json['purchasePrice'] ?? 0).toDouble(),
        sellingPrice: (json['sellingPrice'] ?? 0).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "purchasePrice": purchasePrice,
        "sellingPrice": sellingPrice,
      };
}

class Category {
  final String id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['_id'] ?? '',
        name: json['name'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
      };
}
