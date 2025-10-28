import 'dart:convert';

List<SpecsModel> specsModelFromJson(String str) =>
    List<SpecsModel>.from(json.decode(str).map((x) => SpecsModel.fromJson(x)));

String specsModelToJson(List<SpecsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SpecsModel {
  final String? chipset;
  final int? ram;
  final int? storage;
  final DisplaySpec? display;
  final CameraSpec? cameras;
  final double? batteryHealth;
  final int? chargingW;
  final String? os;
  final List<String>? colors;

  SpecsModel({
    this.chipset,
    this.ram,
    this.storage,
    this.display,
    this.cameras,
    this.batteryHealth,
    this.chargingW,
    this.os,
    this.colors,
  });

  factory SpecsModel.fromJson(Map<String, dynamic> json) => SpecsModel(
        chipset: json['chipset'],
        ram: json['ram'],
        storage: json['storage'],
        display: json['display'] != null
            ? DisplaySpec.fromJson(json['display'])
            : null,
        cameras: json['cameras'] != null
            ? CameraSpec.fromJson(json['cameras'])
            : null,
        batteryHealth: json['batteryHealth'],
        chargingW: json['chargingW'],
        os: json['os'],
        colors: json['colors'] != null ? List<String>.from(json['colors']) : [],
      );

  Map<String, dynamic> toJson() => {
        "chipset": chipset,
        "ram": ram,
        "storage": storage,
        "display": display?.toJson(),
        "cameras": cameras?.toJson(),
        "batteryHealth": batteryHealth,
        "chargingW": chargingW,
        "os": os,
        "colors": colors,
      };
}

class DisplaySpec {
  final double? sizeIn;
  final String? resolution;
  final String? type;
  final int? refreshRate;

  DisplaySpec({this.sizeIn, this.resolution, this.type, this.refreshRate});

  factory DisplaySpec.fromJson(Map<String, dynamic> json) => DisplaySpec(
        sizeIn: (json['sizeIn'] ?? 0).toDouble(),
        resolution: json['resolution'],
        type: json['type'],
        refreshRate: json['refreshRate'],
      );

  Map<String, dynamic> toJson() => {
        "sizeIn": sizeIn,
        "resolution": resolution,
        "type": type,
        "refreshRate": refreshRate,
      };
}

class CameraSpec {
  final String? main;
  final String? front;

  CameraSpec({this.main, this.front});

  factory CameraSpec.fromJson(Map<String, dynamic> json) => CameraSpec(
        main: json['main'],
        front: json['front'],
      );

  Map<String, dynamic> toJson() => {
        "main": main,
        "front": front,
      };
}
