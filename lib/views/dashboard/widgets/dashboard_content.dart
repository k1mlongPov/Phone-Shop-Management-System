import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_shop/common/app_style.dart';
import 'package:phone_shop/common/reusable_text.dart';
import 'package:phone_shop/constants/constants.dart';

class DashboardContent extends StatelessWidget {
  const DashboardContent(
      {super.key,
      required this.iconPath,
      required this.title,
      required this.text,
      required this.color});
  final String iconPath;
  final String title;
  final String text;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5.r),
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: color.withOpacity(0.2),
        border: Border.all(
          width: 1,
          color: color,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(33, 35, 38, 0.1),
            blurRadius: 10,
            spreadRadius: -10,
            offset: Offset(0, 10),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image(
                width: 25.w,
                height: 25.h,
                image: AssetImage(iconPath),
              ),
              ReusableText(
                text: title,
                style: appStyle(14, color, FontWeight.w600),
              ),
            ],
          ),
          ReusableText(
            text: text,
            style: appStyle(16, kDark, FontWeight.normal),
          ),
        ],
      ),
    );
  }
}
