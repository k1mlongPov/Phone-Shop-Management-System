class PhoneModel {
  final String id;
  final String brand;
  final String model;
  final double price;
  final String currency;
  final int stock;
  final String? image;

  PhoneModel({
    required this.id,
    required this.brand,
    required this.model,
    required this.price,
    required this.currency,
    required this.stock,
    this.image,
  });

  factory PhoneModel.fromJson(Map<String, dynamic> json) {
    return PhoneModel(
      id: json['_id'] ?? '',
      brand: json['brand'] ?? '',
      model: json['model'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'USD',
      stock: json['stock'] ?? 0,
      image: (json['images'] != null && json['images'].isNotEmpty)
          ? json['images'][0]
          : null,
    );
  }
}
