import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phone_shop/common/app_style.dart';
import 'package:phone_shop/common/custom_button.dart';
import 'package:phone_shop/common/custom_textfield.dart';
import 'package:phone_shop/common/reusable_text.dart';
import 'package:phone_shop/constants/constants.dart';
import 'package:phone_shop/views/auth/forgot_password_page.dart';
import 'package:phone_shop/views/auth/register_page.dart';

class EmailWidget extends StatelessWidget {
  const EmailWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReusableText(
            text: 'Sign in with your email and password',
            style: appStyle(14, kDark, FontWeight.normal),
          ),
          SizedBox(height: 20.h),
          CustomTextWidget(
            keyBoardType: TextInputType.emailAddress,
            hintText: 'Email',
            prefixIcon: Icon(
              Icons.email_outlined,
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
          SizedBox(
            width: width,
            child: GestureDetector(
              child: ReusableText(
                text: 'Forgot password?',
                textAlign: TextAlign.end,
                style: appStyle(
                  14,
                  kBlue.withOpacity(0.8),
                  FontWeight.normal,
                ),
              ),
              onTap: () => Get.to(() => const ForgotPasswordPage()),
            ),
          ),
          SizedBox(height: 10.h),
          CustomButton(
            text: 'Sign in',
            btnHeight: 40.h,
            radius: 20.r,
            onTap: () {},
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: width * 0.35,
                height: 1.h,
                color: kDark,
              ),
              ReusableText(
                text: 'OR',
                style: appStyle(
                  14,
                  kDark,
                  FontWeight.normal,
                ),
              ),
              Container(
                width: width * 0.35,
                height: 1.h,
                color: kDark,
              ),
            ],
          ),
          SizedBox(height: 20.h),
          CustomButton(
            text: 'Sign in with Google',
            btnHeight: 40.h,
            btnBorderWidth: 1,
            btnColor: kWhite,
            textColor: kDark,
            hasIcon: true,
            imagePath: 'assets/icons/google.png',
            onTap: () {},
          ),
          BottomAppBar(
            color: kWhite,
            elevation: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ReusableText(
                  text: "Don't have an account? ",
                  style: appStyle(
                    14,
                    kDark,
                    FontWeight.normal,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => const RegisterPage());
                  },
                  child: ReusableText(
                    text: 'Sign up',
                    style: appStyle(
                      14,
                      kBlue,
                      FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
