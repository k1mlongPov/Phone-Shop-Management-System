import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phone_shop/common/app_style.dart';
import 'package:phone_shop/common/custom_button.dart';
import 'package:phone_shop/common/reusable_text.dart';
import 'package:phone_shop/constants/constants.dart';
import 'package:phone_shop/views/auth/widgets/otp_input_field.dart';

class VerificationWidget extends StatelessWidget {
  const VerificationWidget(
      {super.key, required this.text, required this.onTap});

  final String text;
  final VoidCallback onTap;
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
                SizedBox(height: 20.h),
                Center(
                  child: ReusableText(
                    text: 'Enter your OTP code',
                    style: appStyle(22, kDark, FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10.h),
                Center(
                  child: ReusableText(
                    textAlign: TextAlign.center,
                    text: text,
                    style: appStyle(14, kDark, FontWeight.normal),
                  ),
                ),
                SizedBox(height: 10.h),
                OtpInputFields(),
                SizedBox(height: 10.h),
                SizedBox(
                  width: width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ReusableText(
                        text: "Didn't receive the code? ",
                        style: appStyle(14, kDark, FontWeight.normal),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: ReusableText(
                          text: 'Resend',
                          style: appStyle(
                            14,
                            kBlue.withOpacity(0.8),
                            FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                CustomButton(
                  text: 'Submit',
                  btnHeight: 40.h,
                  radius: 20.r,
                  onTap: onTap,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
