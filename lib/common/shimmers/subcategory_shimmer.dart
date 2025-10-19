import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_shop/common/shimmers/shimmer_widget.dart';
import 'package:phone_shop/constants/constants.dart';

class SubcategoryShimmer extends StatelessWidget {
  const SubcategoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20.w, top: 8.h),
      width: 140.w,
      height: hieght,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.zero,
        itemCount: 1,
        itemBuilder: (context, index) {
          return ShimmerWidget(
            shimmerWidth: width,
            shimmerHieght: 40.h,
            shimmerRadius: 10.r,
          );
        },
      ),
    );
  }
}
