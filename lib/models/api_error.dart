import 'dart:convert';

ApiError apiErrorFromJson(String str) => ApiError.fromJson(json.decode(str));

String apiErrorToJson(ApiError data) => json.encode(data.toJson());

class ApiError {
  final bool statue;
  final String message;

  ApiError({
    required this.statue,
    required this.message,
  });

  factory ApiError.fromJson(Map<String, dynamic> json) => ApiError(
        statue: json["statue"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "statue": statue,
        "message": message,
      };
}
