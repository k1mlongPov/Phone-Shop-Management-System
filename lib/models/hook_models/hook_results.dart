import 'package:flutter/foundation.dart';

class FetchHook<T> {
  final T? data;
  final bool isLoading;
  final Exception? error;
  final VoidCallback? refetch;

  FetchHook({
    required this.data,
    required this.isLoading,
    required this.error,
    required this.refetch,
  });
}
