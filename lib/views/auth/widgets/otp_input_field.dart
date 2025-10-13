import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phone_shop/common/app_style.dart';
import 'package:phone_shop/constants/constants.dart';
import 'package:phone_shop/controllers/otp_controller.dart';
import 'package:pinput/pinput.dart';

class OtpInputFields extends StatelessWidget {
  final OtpController controller = Get.put(OtpController());

  OtpInputFields({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Pinput(
              length: 6,
              controller: controller.pinController,
              focusNode: controller.focusNode,
              onChanged: controller.onOtpChanged,
              submittedPinTheme: PinTheme(
                width: 56.w,
                height: 60.h,
                textStyle: appStyle(18, kDark, FontWeight.bold),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: kBlue),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
