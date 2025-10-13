import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_shop/common/app_style.dart';
import 'package:phone_shop/common/reusable_text.dart';
import 'package:phone_shop/constants/constants.dart';
import 'package:phone_shop/controllers/dashboard_controller.dart';

class LowStockItems extends StatelessWidget {
  const LowStockItems({
    super.key,
    required this.controller,
  });

  final DashboardController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.r),
      width: width,
      height: 180.h,
      color: kOffWhite,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: controller.lowStockItems.length,
        itemBuilder: (context, index) {
          final item = controller.lowStockItems[index];
          return ListTile(
            leading: const Icon(
              Icons.warning_amber_rounded,
              color: Colors.orange,
            ),
            title: ReusableText(
              text: item['name'],
              style: appStyle(
                14,
                kDark,
                FontWeight.normal,
              ),
            ),
            trailing: ReusableText(
              text: "Stock: ${item['stock']}",
              style: appStyle(
                12,
                Colors.redAccent,
                FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }
}
