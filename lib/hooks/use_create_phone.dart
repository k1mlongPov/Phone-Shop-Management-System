import 'dart:convert';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;
import 'package:phone_shop/constants/constants.dart';
import 'package:phone_shop/models/api_error.dart';

class CreatePhoneHook {
  final bool isLoading;
  final bool success;
  final Exception? error;
  final ApiError? apiError;
  final Future<void> Function(Map<String, dynamic> data) mutate;

  CreatePhoneHook({
    required this.isLoading,
    required this.success,
    required this.error,
    required this.apiError,
    required this.mutate,
  });
}

CreatePhoneHook useCreatePhone() {
  final isLoading = useState(false);
  final success = useState(false);
  final error = useState<Exception?>(null);
  final apiError = useState<ApiError?>(null);

  Future<void> mutate(Map<String, dynamic> data) async {
    isLoading.value = true;
    success.value = false;
    try {
      final url = Uri.parse('$appBaseUrl/api/phones');
      final res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (res.statusCode == 201 || res.statusCode == 200) {
        success.value = true;
      } else {
        apiError.value = apiErrorFromJson(res.body);
      }
    } catch (e) {
      error.value = e is Exception ? e : Exception(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  return CreatePhoneHook(
    isLoading: isLoading.value,
    success: success.value,
    error: error.value,
    apiError: apiError.value,
    mutate: mutate,
  );
}
