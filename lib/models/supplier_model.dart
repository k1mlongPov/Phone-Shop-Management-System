import 'dart:convert';

List<SupplierModel> supplierModelFromJson(String str) {
  final decoded = json.decode(str);

  if (decoded is List) {
    // backend returned a plain array: [ {..}, {..} ]
    return decoded
        .map((e) => SupplierModel.fromJson(e as Map<String, dynamic>))
        .toList();
  } else if (decoded is Map<String, dynamic>) {
    // backend returned an object; try to find a "data" array inside
    if (decoded['data'] is List) {
      return (decoded['data'] as List)
          .map((e) => SupplierModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
  }

  // If neither, throw a nice error for debugging
  throw FormatException(
      'Unexpected JSON format for suppliers: ${str.substring(0, str.length > 200 ? 200 : str.length)}');
}

String supplierModelToJson(List<SupplierModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SupplierModel {
  final String id;
  final String name;
  final String? contactName;
  final String? phone;
  final String? email;
  final String? address;
  final String? notes;
  final bool active;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SupplierModel({
    required this.id,
    required this.name,
    this.contactName,
    this.phone,
    this.email,
    this.address,
    this.notes,
    required this.active,
    this.createdAt,
    this.updatedAt,
  });

  factory SupplierModel.fromJson(Map<String, dynamic> json) => SupplierModel(
        id: json['_id'] ?? '',
        name: json['name'] ?? '',
        contactName: json['contactName'],
        phone: json['phone'],
        email: json['email'],
        address: json['address'],
        notes: json['notes'],
        active: json['active'] ?? true,
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'])
            : null,
        updatedAt: json['updatedAt'] != null
            ? DateTime.tryParse(json['updatedAt'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "contactName": contactName,
        "phone": phone,
        "email": email,
        "address": address,
        "notes": notes,
        "active": active,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
