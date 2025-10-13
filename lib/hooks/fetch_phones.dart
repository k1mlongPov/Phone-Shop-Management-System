import 'package:dio/dio.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:phone_shop/constants/constants.dart';
import 'package:phone_shop/models/phones_model.dart';
import '../../models/hook_models/hook_results.dart';

FetchHook<List<PhoneModel>> useFetchPhones() {
  final isLoading = useState(false);
  final data = useState<List<PhoneModel>?>(null);
  final error = useState<Exception?>(null);

  final dio = Dio(BaseOptions(baseUrl: '$appBaseUrl/api'));

  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      error.value = null;

      final response = await dio.get('/phones', queryParameters: {
        'page': 1,
        'limit': 12,
      });

      final responseData = response.data['data'] as List;
      data.value = responseData.map((e) => PhoneModel.fromJson(e)).toList();
    } on DioException catch (e) {
      error.value = Exception(e.message);
    } catch (e) {
      error.value = Exception(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch data once when the hook is first called
  useEffect(() {
    fetchData();
    return null;
  }, []);

  return FetchHook<List<PhoneModel>>(
    data: data.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: fetchData,
  );
}
