import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:phone_shop/controllers/supplier_controller.dart';

abstract class BaseProductController<T> extends GetxController {
  var isLoading = false.obs;
  var items = <T>[].obs;
  var selectedSubcategoryId = ''.obs;
  var searchQuery = ''.obs;
  var sortOption = ''.obs;

  var page = 1.obs;
  final int limit = 12;
  var hasMore = true.obs;
  Timer? _debounce;

  final ScrollController scrollController = ScrollController();

  String get endpoint; // to be provided by subclass
  T fromJson(Map<String, dynamic> json); // model converter

  @override
  void onInit() {
    super.onInit();
    fetchItems(reset: true);
    final supplierController = Get.find<SupplierController>();
    supplierController.fetchSuppliers();

    // Infinite scroll listener
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 200 &&
          !isLoading.value &&
          hasMore.value) {
        loadNextPage();
      }
    });
  }

  Future<void> fetchItems({
    bool reset = false,
    String? categoryId,
    String? query,
    String? sort,
  }) async {
    if (isLoading.value || (!hasMore.value && !reset)) return;

    if (reset) {
      page.value = 1;
      hasMore.value = true;
      items.clear();
    }

    isLoading.value = true;
    try {
      final params = <String, String>{
        'page': page.value.toString(),
        'limit': limit.toString(),
      };
      if (categoryId != null && categoryId.isNotEmpty) {
        params['category'] = categoryId;
      }
      if (query != null && query.isNotEmpty) params['q'] = query;
      if (sort != null && sort.isNotEmpty) params['sort'] = sort;

      final uri = Uri.parse(endpoint).replace(queryParameters: params);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List<dynamic> data = decoded['data'] ?? [];

        if (data.isEmpty) {
          hasMore.value = false;
        } else {
          final fetched = List<T>.from(data.map((e) => fromJson(e)));
          items.addAll(fetched);

          final totalPages = decoded['pages'] ?? 1;
          if (page.value >= totalPages) hasMore.value = false;
        }
      } else {
        items.clear();
        debugPrint('Failed to fetch items: ${response.statusCode}');
      }
    } catch (e) {
      e.printError();
      items.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void loadNextPage() {
    if (hasMore.value && !isLoading.value) {
      page.value++;
      fetchItems(
        categoryId: selectedSubcategoryId.value,
        query: searchQuery.value,
        sort: sortOption.value,
      );
    }
  }

  void search(String query) {
    searchQuery.value = query;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      fetchItems(
        reset: true,
        categoryId: selectedSubcategoryId.value,
        query: query,
        sort: sortOption.value,
      );
    });
  }

  void sort(String option) {
    sortOption.value = option;
    fetchItems(
      reset: true,
      categoryId: selectedSubcategoryId.value,
      query: searchQuery.value,
      sort: option,
    );
  }

  void selectSubcategory(String subcategoryId) {
    selectedSubcategoryId.value = subcategoryId;
    fetchItems(
      reset: true,
      categoryId: subcategoryId.isEmpty ? null : subcategoryId,
      query: searchQuery.value,
      sort: sortOption.value,
    );
  }

  Future<void> refetch() async {
    await fetchItems(
      reset: true,
      categoryId: selectedSubcategoryId.value,
      query: searchQuery.value,
      sort: sortOption.value,
    );
  }

  void resetFilter() {
    selectedSubcategoryId.value = '';
    fetchItems(reset: true);
  }

  @override
  void onClose() {
    _debounce?.cancel();
    scrollController.dispose();
    super.onClose();
  }
}
