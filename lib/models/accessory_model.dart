import 'dart:convert';
import 'package:phone_shop/models/category_model.dart';
import 'package:phone_shop/models/pricing_model.dart';
import 'package:phone_shop/models/supplier_model.dart';

List<AccessoryModel> accessoryModelFromJson(String str) =>
    List<AccessoryModel>.from(
        json.decode(str)["data"].map((x) => AccessoryModel.fromJson(x)));

String accessoryModelToJson(List<AccessoryModel> data) =>
    json.encode({"data": List<dynamic>.from(data.map((x) => x.toJson()))});

class AccessoryModel {
  final String id;
  final String name;
  final String type;
  final String? brand;
  final Pricing pricing;
  final String currency;
  final String? sku;
  final List<String> images;
  final List<String>? compatibility;
  final int stock;
  final int lowStockThreshold;
  final Map<String, dynamic>? attributes;
  final CategoryModel? category;
  final SupplierModel? supplier;
  final bool isActive;
  final double profitMargin;

  AccessoryModel({
    required this.id,
    required this.name,
    required this.type,
    this.brand,
    required this.pricing,
    required this.currency,
    this.sku,
    required this.images,
    this.compatibility,
    required this.stock,
    required this.lowStockThreshold,
    this.attributes,
    this.category,
    this.supplier,
    required this.isActive,
    required this.profitMargin,
  });

  factory AccessoryModel.fromJson(Map<String, dynamic> json) => AccessoryModel(
        id: json['_id'] ?? '',
        name: json['name'] ?? '',
        type: json['type'] ?? '',
        brand: json['brand'],
        pricing: Pricing.fromJson(json['pricing'] ?? {}),
        currency: json['currency'] ?? 'USD',
        sku: json['sku'],
        images: List<String>.from(json['images'] ?? []),
        compatibility: json['compatibility'] != null
            ? List<String>.from(json['compatibility'])
            : [],
        stock: json['stock'] ?? 0,
        lowStockThreshold: json['lowStockThreshold'] ?? 10,
        attributes: json['attributes'] ?? {},
        category: json['category'] != null
            ? CategoryModel.fromJson(json['category'])
            : null,
        supplier: json['supplier'] != null &&
                json['supplier'] is Map<String, dynamic> &&
                json['supplier'].isNotEmpty
            ? SupplierModel.fromJson(json['supplier'])
            : null,
        isActive: json['isActive'] ?? true,
        profitMargin: (json['profitMargin'] ?? 0).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "type": type,
        "brand": brand,
        "pricing": pricing.toJson(),
        "currency": currency,
        "sku": sku,
        "images": images,
        "compatibility": compatibility,
        "stock": stock,
        "lowStockThreshold": lowStockThreshold,
        "attributes": attributes,
        "category": category?.toJson(),
        "supplier": supplier?.toJson(),
        "isActive": isActive,
        "profitMargin": profitMargin,
      };
}
