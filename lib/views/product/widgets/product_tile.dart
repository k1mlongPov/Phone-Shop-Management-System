import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_shop/common/app_style.dart';
import 'package:phone_shop/common/reusable_text.dart';
import 'package:phone_shop/constants/constants.dart';

class ProductTile extends StatelessWidget {
  const ProductTile({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  final String image;
  final String title;
  final String subtitle;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 70.h,
      decoration: const BoxDecoration(
        color: kWhite,
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            blurRadius: 3,
            spreadRadius: 0,
            offset: Offset(0, 1),
          ),
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.06),
            blurRadius: 2,
            spreadRadius: 0,
            offset: Offset(0, 1),
          )
        ],
      ),
      child: ListTile(
        leading: Image.network(
          image,
          width: 50.w,
          height: 50.h,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              const Icon(Icons.broken_image, size: 40),
        ),
        title: ReusableText(
          text: title,
          style: appStyle(14, kDark, FontWeight.w600),
        ),
        subtitle: ReusableText(
          text: subtitle,
          style: appStyle(12, kBlue, FontWeight.normal),
        ),
        trailing: ReusableText(
          text: trailing,
          style: appStyle(12, kGray, FontWeight.normal),
        ),
      ),
    );
  }
}
