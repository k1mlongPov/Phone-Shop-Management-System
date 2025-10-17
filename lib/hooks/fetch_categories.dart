import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:phone_shop/constants/constants.dart';
import 'package:phone_shop/models/api_error.dart';
import 'package:phone_shop/models/category_model.dart';

class FetchResult<T> {
  final T? data;
  final bool isLoading;
  final Exception? error;
  final ApiError? apiError;
  final VoidCallback refetch;

  FetchResult({
    required this.data,
    required this.isLoading,
    required this.error,
    required this.apiError,
    required this.refetch,
  });
}

final _box = GetStorage();

FetchResult<List<CategoryModel>> useFetchCategories() {
  final data = useState<List<CategoryModel>?>(null);
  final isLoading = useState(false);
  final error = useState<Exception?>(null);
  final apiError = useState<ApiError?>(null);

  Future<void> fetchData({bool forceRefresh = false}) async {
    isLoading.value = true;
    error.value = null;
    apiError.value = null;

    try {
      if (!forceRefresh) {
        final cached = _box.read('cached_categories');
        if (cached != null) {
          data.value = categoryModelFromJson(cached);
        }
      }

      final response = await http.get(Uri.parse('$appBaseUrl/api/categories'));
      if (response.statusCode == 200) {
        final categories = categoryModelFromJson(response.body);
        data.value = categories;

        await _box.write('cached_categories', response.body);
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

  void refetch() => fetchData(forceRefresh: true);

  return FetchResult(
    data: data.value,
    isLoading: isLoading.value,
    error: error.value,
    apiError: apiError.value,
    refetch: refetch,
  );
}

FetchResult<List<CategoryModel>> useFetchSubCategories(String parentId) {
  final data = useState<List<CategoryModel>?>(null);
  final isLoading = useState(false);
  final error = useState<Exception?>(null);
  final apiError = useState<ApiError?>(null);

  Future<void> fetchData({bool forceRefresh = false}) async {
    isLoading.value = true;
    error.value = null;
    apiError.value = null;

    final cacheKey = 'cached_sub_$parentId';

    try {
      if (!forceRefresh) {
        final cached = _box.read(cacheKey);
        if (cached != null) {
          data.value = categoryModelFromJson(cached);
        }
      }

      final response = await http
          .get(Uri.parse('$appBaseUrl/api/categories/$parentId/subcategories'));

      if (response.statusCode == 200) {
        final subcategories = categoryModelFromJson(response.body);
        data.value = subcategories;

        await _box.write(cacheKey, response.body);
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
  }, [parentId]);

  void refetch() => fetchData(forceRefresh: true);

  return FetchResult(
    data: data.value,
    isLoading: isLoading.value,
    error: error.value,
    apiError: apiError.value,
    refetch: refetch,
  );
}
