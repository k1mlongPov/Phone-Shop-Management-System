import 'dart:io';
import 'package:phone_shop/models/variant_form_data.dart';

class PhoneFormData {
  final String brand;
  final String model;
  final String slug;
  final double purchasePrice;
  final double sellingPrice;
  final String os;
  final String chipset;
  final String categoryId;
  final String supplierId;
  final int stock;
  final int lowStockThreshold;
  final double batteryHealth;
  final List<File> newImages;
  final List<String> existingImages;
  final List<VariantFormData> variants;

  PhoneFormData({
    required this.brand,
    required this.model,
    required this.slug,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.os,
    required this.chipset,
    required this.categoryId,
    required this.supplierId,
    required this.stock,
    required this.lowStockThreshold,
    required this.batteryHealth,
    required this.newImages,
    required this.existingImages,
    required this.variants,
  });

  /// ✅ Convert to JSON (for saving locally or debug)
  Map<String, dynamic> toJson() {
    return {
      "brand": brand,
      "model": model,
      "slug": slug,
      "pricing": {
        "purchasePrice": purchasePrice,
        "sellingPrice": sellingPrice,
      },
      "specs": {
        "os": os,
        "chipset": chipset,
        "batteryHealth": batteryHealth,
      },
      "category": categoryId,
      "supplier": supplierId,
      "stock": stock,
      "lowStockThreshold": lowStockThreshold,
      "variants": variants.map((v) => v.toJson()).toList(),
      "existingImages": existingImages,
    };
  }

  /// ✅ For sending to backend (multipart/form-data)
  Map<String, String> toFormFields() {
    final fields = <String, String>{};

    // Basic info
    fields['brand'] = brand;
    fields['model'] = model;
    fields['slug'] = slug;
    fields['pricing[purchasePrice]'] = purchasePrice.toString();
    fields['pricing[sellingPrice]'] = sellingPrice.toString();

    // Specs
    fields['specs[os]'] = os;
    fields['specs[chipset]'] = chipset;
    fields['specs[batteryHealth]'] = batteryHealth.toString();

    // Metadata
    fields['category'] = categoryId;
    fields['supplier'] = supplierId;
    fields['stock'] = stock.toString();
    fields['lowStockThreshold'] = lowStockThreshold.toString();

    // ✅ Variants (using Pricing model)
    for (int i = 0; i < variants.length; i++) {
      final v = variants[i];
      fields['variants[$i][storage]'] = v.storage;
      if (v.color != null && v.color!.isNotEmpty) {
        fields['variants[$i][color]'] = v.color!;
      }

      // Access pricing inside the nested model
      fields['variants[$i][pricing][purchasePrice]'] =
          v.pricing.purchasePrice.toString();
      fields['variants[$i][pricing][sellingPrice]'] =
          v.pricing.sellingPrice.toString();

      fields['variants[$i][stock]'] = v.stock.toString();

      if (v.sku != null && v.sku!.isNotEmpty) {
        fields['variants[$i][sku]'] = v.sku!;
      }
    }

    return fields;
  }

  /// ✅ For editing use-cases
  PhoneFormData copyWith({
    String? brand,
    String? model,
    String? slug,
    double? purchasePrice,
    double? sellingPrice,
    String? os,
    String? chipset,
    String? categoryId,
    String? supplierId,
    int? stock,
    int? lowStockThreshold,
    double? batteryHealth,
    List<File>? newImages,
    List<String>? existingImages,
    List<VariantFormData>? variants,
  }) {
    return PhoneFormData(
      brand: brand ?? this.brand,
      model: model ?? this.model,
      slug: slug ?? this.slug,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      os: os ?? this.os,
      chipset: chipset ?? this.chipset,
      categoryId: categoryId ?? this.categoryId,
      supplierId: supplierId ?? this.supplierId,
      stock: stock ?? this.stock,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      batteryHealth: batteryHealth ?? this.batteryHealth,
      newImages: newImages ?? this.newImages,
      existingImages: existingImages ?? this.existingImages,
      variants: variants ?? this.variants,
    );
  }
}
