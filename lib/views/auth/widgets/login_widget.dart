import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phone_shop/common/app_style.dart';
import 'package:phone_shop/common/reusable_text.dart';
import 'package:phone_shop/constants/constants.dart';
import 'package:phone_shop/controllers/switch_controller.dart';
import 'package:phone_shop/views/auth/widgets/email_phone_switch.dart';
import 'package:phone_shop/views/auth/widgets/email_widget.dart';
import 'package:phone_shop/views/auth/widgets/phone_widget.dart';

class LoginWidget extends StatelessWidget {
  const LoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final SwitchController switchController = Get.put(SwitchController());
    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50.r),
            topRight: Radius.circular(50.r),
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(30.r),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ReusableText(
                    text: 'Login',
                    style: appStyle(22, kDark, FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10.h),
                EmailPhoneSwitch(),
                Obx(
                  () {
                    return switchController.isSwitch.value
                        ? const EmailWidget()
                        : const PhoneWidget();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
