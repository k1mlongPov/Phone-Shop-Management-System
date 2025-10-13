import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_shop/common/app_style.dart';
import 'package:phone_shop/common/reusable_text.dart';
import 'package:phone_shop/constants/constants.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 20.h),
        padding: EdgeInsets.only(left: 10.w, right: 10.w),
        width: width,
        height: 80.h,
        color: kBlue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25.r,
                  backgroundColor: kGray,
                  backgroundImage: const NetworkImage(
                      'https://images.pexels.com/photos/91227/pexels-photo-91227.jpeg'),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(6.w, 15.h, 0, 15.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ReusableText(
                        text: "${getTimeOfDay()} Admin!",
                        style: appStyle(
                          16.sp,
                          kWhite,
                          FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: width * 0.55,
                        child: Text(
                          'Welcome back',
                          overflow: TextOverflow.ellipsis,
                          style: appStyle(
                            12.sp,
                            kOffWhite,
                            FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.circular(5.r),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(33, 35, 38, 0.1),
                    blurRadius: 10,
                    spreadRadius: -10,
                    offset: Offset(0, 10),
                  )
                ],
              ),
              child: const Icon(
                Icons.notifications,
                color: kGray,
              ),
            )
          ],
        ),
      ),
    );
  }

  String getTimeOfDay() {
    DateTime now = DateTime.now();
    int hour = now.hour;

    if (hour >= 0 && hour < 12) {
      return 'Good morning';
    } else if (hour >= 12 && hour < 16) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }
}
