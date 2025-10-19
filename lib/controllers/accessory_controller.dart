import 'package:phone_shop/constants/constants.dart';
import 'package:phone_shop/controllers/base_product_controller.dart';
import 'package:phone_shop/models/accessory_model.dart';

class AccessoryController extends BaseProductController<AccessoryModel> {
  @override
  String get endpoint => '$appBaseUrl/api/accessories';

  @override
  AccessoryModel fromJson(Map<String, dynamic> json) =>
      AccessoryModel.fromJson(json);
}
