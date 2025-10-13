import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpController extends GetxController {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  var otpCode = ''.obs;

  void onOtpChanged(String value) {
    otpCode.value = value;
  }

  @override
  void onClose() {
    pinController.dispose();
    focusNode.dispose();
    super.onClose();
  }
}
