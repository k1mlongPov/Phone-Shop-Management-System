import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_shop/constants/constants.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer(
      {super.key, required this.containerContent, this.color});

  final Color? color;

  final Widget containerContent;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 220.h,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
        child: Container(
          width: width,
          color: color ?? kWhite,
          child: containerContent,
        ),
      ),
    );
  }
}
