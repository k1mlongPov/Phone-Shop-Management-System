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
