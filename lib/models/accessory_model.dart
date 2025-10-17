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
  final double purchasePrice;
  final double sellingPrice;
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
    required this.purchasePrice,
    required this.sellingPrice,
    required this.currency,
    this.sku,
    required this.images,
    required this.isActive,
    required this.profitMargin,
    required this.stock,
  });

  factory AccessoryModel.fromJson(Map<String, dynamic> json) {
    final pricing = json['pricing'] ?? {};
    return AccessoryModel(
      id: json['_id'],
      name: json['name'],
      type: json['type'],
      brand: json['brand'],
      purchasePrice: (pricing['purchasePrice'] ?? 0).toDouble(),
      sellingPrice: (pricing['sellingPrice'] ?? 0).toDouble(),
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
        "pricing": {
          "purchasePrice": purchasePrice,
          "sellingPrice": sellingPrice,
        },
        "currency": currency,
        "sku": sku,
        "images": images,
        "isActive": isActive,
        "profitMargin": profitMargin,
        "stock": stock,
      };
}
