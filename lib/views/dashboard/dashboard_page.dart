import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phone_shop/common/app_style.dart';
import 'package:phone_shop/common/custom_appbar.dart';
import 'package:phone_shop/common/custom_container.dart';
import 'package:phone_shop/common/reusable_text.dart';
import 'package:phone_shop/constants/constants.dart';
import 'package:phone_shop/controllers/dashboard_controller.dart';
import 'package:phone_shop/views/dashboard/dashboard.dart';
import 'package:phone_shop/views/dashboard/low_stock_items.dart';
import 'package:phone_shop/views/dashboard/profit_overview.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.put(DashboardController());
    return Scaffold(
      backgroundColor: kBlue,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.h),
        child: const CustomAppbar(),
      ),
      body: CustomContainer(
        color: kWhite,
        containerContent: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 18.w),
                child: ReusableText(
                  text: 'Dashboard',
                  style: appStyle(22, kDark, FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              Dashboard(),
              SizedBox(
                height: 10.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 18.w, right: 18.w),
                child: ReusableText(
                  text: 'Profit Overview',
                  style: appStyle(22, kDark, FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              MonthlyProfitChart(),
              SizedBox(
                height: 10.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 18.w, right: 18.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ReusableText(
                      text: 'Low stock items',
                      style: appStyle(22, kDark, FontWeight.bold),
                    ),
                    Image(
                      width: 20.w,
                      height: 20.h,
                      image:
                          const AssetImage('assets/icons/categories_icon.png'),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              LowStockItems(controller: controller),
              SizedBox(
                height: 30.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
