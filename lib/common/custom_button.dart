import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_shop/common/app_style.dart';
import 'package:phone_shop/common/reusable_text.dart';
import 'package:phone_shop/constants/constants.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.onTap,
    this.btnWidth,
    this.btnHeight,
    this.btnColor,
    this.radius,
    required this.text,
    this.btnBorderWidth,
    this.hasIcon,
    this.imagePath,
    this.textColor,
  });

  final void Function()? onTap;
  final double? btnWidth;
  final double? btnHeight;
  final double? btnBorderWidth;
  final Color? textColor;
  final Color? btnColor;
  final double? radius;
  final String text;
  final String? imagePath;
  final bool? hasIcon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: btnWidth ?? width,
        height: btnHeight ?? 28.h,
        decoration: BoxDecoration(
          color: btnColor ?? kBlue,
          border: Border.all(
              color: kBlue.withOpacity(0.5), width: btnBorderWidth ?? 0),
          borderRadius: BorderRadius.circular(radius ?? 12.r),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              hasIcon == true
                  ? Container(
                      margin: EdgeInsets.only(right: 10.w),
                      width: 25.w,
                      height: 25.w,
                      child: Image.asset(imagePath!),
                    )
                  : Container(),
              ReusableText(
                text: text,
                style: appStyle(
                  14,
                  textColor ?? kWhite,
                  FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
