import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phone_shop/constants/constants.dart';
import 'package:phone_shop/controllers/dashboard_controller.dart';
import 'package:phone_shop/views/dashboard/widgets/dashboard_content.dart';

class Dashboard extends StatelessWidget {
  Dashboard({super.key});
  final dashboardController = Get.put(DashboardController());
  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Container(
          padding: EdgeInsets.all(8.r),
          width: width,
          height: 250.h,
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: DashboardContent(
                        iconPath: 'assets/icons/smartphone_icon.png',
                        title: 'Phones',
                        text: 'Total: ${dashboardController.totalPhones}',
                      ),
                    ),
                    Expanded(
                      child: DashboardContent(
                        iconPath: 'assets/icons/headphones_icon.png',
                        title: 'Accessories',
                        text: 'Total: ${dashboardController.totalAccessories}',
                      ),
                    ),
                  ],
                ),
              ),
              // Second Row
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: DashboardContent(
                        iconPath: 'assets/icons/folder_icon.png',
                        title: 'Categories',
                        text:
                            'Total: ${dashboardController.totalSubCategories}',
                      ),
                    ),
                    Expanded(
                      child: DashboardContent(
                        iconPath: 'assets/icons/dollar_icon.png',
                        title: 'Purchase Value',
                        text:
                            'Total: ${dashboardController.totalPurchaseValue}\$',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
