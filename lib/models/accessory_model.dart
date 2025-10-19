import 'dart:convert';

List<AccessoryModel> accessoryModelFromJson(String str) =>
    List<AccessoryModel>.from(
        json.decode(str).map((x) => AccessoryModel.fromJson(x)));

String accessoryModelToJson(List<AccessoryModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AccessoryModel {
  final String id;
  final String name;
  final String type;
  final String? brand;
  final Pricing pricing;
  final String currency;
  final String? sku;
  final List<String> images;
  final bool isActive;
  final double profitMargin;
  final int stock;

  AccessoryModel({
    required this.id,
    required this.name,
    required this.type,
    this.brand,
    required this.pricing,
    required this.currency,
    this.sku,
    required this.images,
    required this.isActive,
    required this.profitMargin,
    required this.stock,
  });

  factory AccessoryModel.fromJson(Map<String, dynamic> json) {
    return AccessoryModel(
      id: json['_id'],
      name: json['name'],
      type: json['type'],
      brand: json['brand'],
      pricing: Pricing.fromJson(json['pricing'] ?? {}),
      currency: json['currency'] ?? 'USD',
      sku: json['sku'],
      images: List<String>.from(json['images'] ?? []),
      isActive: json['isActive'] ?? true,
      profitMargin: (json['profitMargin'] ?? 0).toDouble(),
      stock: json['stock'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "type": type,
        "brand": brand,
        "pricing": pricing.toJson(),
        "currency": currency,
        "sku": sku,
        "images": images,
        "isActive": isActive,
        "profitMargin": profitMargin,
        "stock": stock,
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
