import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;
import '../models/accessory_model.dart';
import '../models/api_error.dart';
import '../constants/constants.dart';

class FetchAccessories {
  final List<AccessoryModel>? data;
  final bool isLoading;
  final Exception? error;
  final ApiError? apiError;
  final VoidCallback refetch;

  FetchAccessories({
    required this.data,
    required this.isLoading,
    required this.error,
    required this.apiError,
    required this.refetch,
  });
}

FetchAccessories useFetchAccessories() {
  final accessories = useState<List<AccessoryModel>?>(null);
  final isLoading = useState<bool>(false);
  final error = useState<Exception?>(null);
  final apiError = useState<ApiError?>(null);

  Future<void> fetchData() async {
    isLoading.value = true;
    try {
      final url = Uri.parse('$appBaseUrl/api/accessories');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        accessories.value = accessoryModelFromJson(response.body);
      } else {
        apiError.value = apiErrorFromJson(response.body);
      }
    } catch (e) {
      error.value = e is Exception ? e : Exception(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  useEffect(() {
    fetchData();
    return null;
  }, []);

  void refetch() => fetchData();

  return FetchAccessories(
    data: accessories.value,
    isLoading: isLoading.value,
    error: error.value,
    apiError: apiError.value,
    refetch: refetch,
  );
}
