import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_shop/common/app_style.dart';
import 'package:phone_shop/common/reusable_text.dart';
import 'package:phone_shop/constants/constants.dart';
import 'package:phone_shop/views/auth/widgets/verification_widget.dart';

class VerificationPage extends StatelessWidget {
  const VerificationPage({super.key, this.text, this.onTap});
  final String? text;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlue,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: 125.h,
              child: const Image(
                image: AssetImage(
                  'assets/images/Vetheary-logo.png',
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 25.w, bottom: 20.w),
              child: ReusableText(
                text: 'Welcome back!',
                style: appStyle(24, kWhite, FontWeight.w600),
              ),
            ),
            VerificationWidget(
              text: text ??
                  'Check your phone, We have sent the code verification to +885719997174',
              onTap: onTap ?? () {},
            ),
          ],
        ),
      ),
    );
  }
}
