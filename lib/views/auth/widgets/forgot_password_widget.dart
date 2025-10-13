import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phone_shop/common/app_style.dart';
import 'package:phone_shop/common/custom_button.dart';
import 'package:phone_shop/common/custom_textfield.dart';
import 'package:phone_shop/common/reusable_text.dart';
import 'package:phone_shop/constants/constants.dart';
import 'package:phone_shop/views/auth/reset_password_page.dart';
import 'package:phone_shop/views/auth/verification_page.dart';

class ForgotPasswordWidget extends StatelessWidget {
  const ForgotPasswordWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
                Row(
                  children: [
                    GestureDetector(
                      child: Icon(
                        Icons.arrow_back_sharp,
                        size: 20.r,
                      ),
                      onTap: () => Get.back(),
                    ),
                    SizedBox(width: 5.w),
                    ReusableText(
                      text: 'Back',
                      style: appStyle(14, kDark, FontWeight.normal),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Center(
                  child: ReusableText(
                    text: 'Forgot Password?',
                    style: appStyle(22, kDark, FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10.h),
                Center(
                  child: ReusableText(
                    text:
                        "Don't worry! It happens. Please enter the address associated with your account.",
                    textAlign: TextAlign.center,
                    style: appStyle(14, kDark, FontWeight.normal),
                  ),
                ),
                SizedBox(height: 20.h),
                CustomTextWidget(
                  keyBoardType: TextInputType.emailAddress,
                  hintText: 'Email',
                  prefixIcon: Icon(
                    Icons.mail,
                    color: kGray,
                    size: 18.sp,
                  ),
                ),
                SizedBox(height: 20.h),
                CustomButton(
                  text: 'Get OTP',
                  btnHeight: 40.h,
                  radius: 20.r,
                  onTap: () {
                    Get.to(
                      () => VerificationPage(
                        text:
                            'Check your Email address we have sent you the code to abc@gmail.com',
                        onTap: () {
                          Get.to(() => const ResetPasswordPage());
                        },
                      ),
                    );
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
