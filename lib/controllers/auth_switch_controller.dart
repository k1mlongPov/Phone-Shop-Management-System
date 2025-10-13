import 'package:get/get.dart';

class AuthSwitchController extends GetxController {
  /// true = Email, false = Phone
  var isEmail = true.obs;

  void toggleToEmail() => isEmail.value = true;
  void toggleToPhone() => isEmail.value = false;
}
