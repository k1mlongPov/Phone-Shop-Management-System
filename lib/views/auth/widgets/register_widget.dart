import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phone_shop/common/app_style.dart';
import 'package:phone_shop/common/custom_button.dart';
import 'package:phone_shop/common/custom_textfield.dart';
import 'package:phone_shop/common/reusable_text.dart';
import 'package:phone_shop/constants/constants.dart';
import 'package:phone_shop/views/auth/verification_page.dart';

class RegisterWidget extends StatelessWidget {
  const RegisterWidget({super.key});

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
                      text: 'Back to login',
                      style: appStyle(14, kDark, FontWeight.normal),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                ReusableText(
                  text: 'Register',
                  style: appStyle(22, kDark, FontWeight.bold),
                ),
                SizedBox(height: 10.h),
                ReusableText(
                  text: 'Sign up with your email address',
                  style: appStyle(14, kDark, FontWeight.normal),
                ),
                SizedBox(height: 10.h),
                CustomTextWidget(
                  keyBoardType: TextInputType.text,
                  hintText: 'Username',
                  prefixIcon: Icon(
                    Icons.person,
                    color: kGray,
                    size: 18.sp,
                  ),
                ),
                SizedBox(height: 10.h),
                CustomTextWidget(
                  keyBoardType: TextInputType.emailAddress,
                  hintText: 'Email',
                  prefixIcon: Icon(
                    Icons.email,
                    color: kGray,
                    size: 18.sp,
                  ),
                ),
                SizedBox(height: 10.h),
                CustomTextWidget(
                  keyBoardType: TextInputType.emailAddress,
                  hintText: 'Password',
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: kGray,
                    size: 18.sp,
                  ),
                  suffixIcon: Icon(
                    Icons.remove_red_eye_outlined,
                    color: kGray,
                    size: 18.sp,
                  ),
                ),
                SizedBox(height: 10.h),
                CustomTextWidget(
                  keyBoardType: TextInputType.emailAddress,
                  hintText: 'Confirm password',
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: kGray,
                    size: 18.sp,
                  ),
                  suffixIcon: Icon(
                    Icons.remove_red_eye_outlined,
                    color: kGray,
                    size: 18.sp,
                  ),
                ),
                SizedBox(height: 20.h),
                CustomButton(
                  text: 'Sign up',
                  btnHeight: 40.h,
                  radius: 20.r,
                  onTap: () {
                    Get.to(
                      () => const VerificationPage(
                        text:
                            'Check your Email address we have sent you the code to abc@gmail.com',
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
