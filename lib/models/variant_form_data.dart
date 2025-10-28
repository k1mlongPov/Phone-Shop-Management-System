import 'package:phone_shop/models/pricing_model.dart';

class VariantFormData {
  final String storage;
  final String? color;
  final Pricing pricing;
  final int stock;
  final String? sku;

  VariantFormData({
    required this.storage,
    this.color,
    required this.pricing,
    required this.stock,
    this.sku,
  });

  factory VariantFormData.fromJson(Map<String, dynamic> json) =>
      VariantFormData(
        storage: json['storage'] ?? '',
        color: json['color'],
        pricing: json['pricing'] != null
            ? Pricing.fromJson(json['pricing'])
            : Pricing(purchasePrice: 0, sellingPrice: 0),
        stock: json['stock'] != null
            ? int.tryParse(json['stock'].toString()) ?? 0
            : 0,
        sku: json['sku'],
      );

  Map<String, dynamic> toJson() => {
        "storage": storage,
        if (color != null) "color": color,
        "pricing": pricing.toJson(),
        "stock": stock,
        if (sku != null) "sku": sku,
      };

  VariantFormData copyWith({
    String? storage,
    String? color,
    Pricing? pricing,
    int? stock,
    String? sku,
  }) {
    return VariantFormData(
      storage: storage ?? this.storage,
      color: color ?? this.color,
      pricing: pricing ?? this.pricing,
      stock: stock ?? this.stock,
      sku: sku ?? this.sku,
    );
  }
}
