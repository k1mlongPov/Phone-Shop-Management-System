import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phone_shop/common/app_style.dart';
import 'package:phone_shop/common/custom_button.dart';
import 'package:phone_shop/common/reusable_text.dart';
import 'package:phone_shop/constants/constants.dart';
import 'package:phone_shop/views/auth/login_page.dart';

class WelcomeWidget extends StatelessWidget {
  const WelcomeWidget({
    super.key,
  });

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
        child: Column(
          children: [
            Container(
              height: 250.h,
              //margin: EdgeInsets.only(top: 25.h),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.r),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50.r),
                child: const Image(
                  image: AssetImage('assets/images/phone_shop.jpg'),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 150.h,
              padding: EdgeInsets.only(left: 25.w, right: 25.w),
              child: ReusableText(
                text:
                    'Welcome to Vetheary Phone Store, your trusted destination for the latest smartphones, accessories, and mobile solutions.',
                textAlign: TextAlign.center,
                style: appStyle(14, kDark, FontWeight.normal),
              ),
            ),
            CustomButton(
              text: 'Get Started',
              btnWidth: 300.w,
              btnHeight: 40.h,
              onTap: () => Get.to(() => const LoginPage()),
            ),
          ],
        ),
      ),
    );
  }
}
