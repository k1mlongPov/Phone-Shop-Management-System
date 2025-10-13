import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_shop/constants/constants.dart';
import 'package:phone_shop/views/dashboard/widgets/dashboard_content.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.r),
      width: width,
      height: 250.h,
      decoration: const BoxDecoration(
        color: kOffWhite,
      ),
      child: const Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: DashboardContent(
                    iconPath: 'assets/icons/smartphone_icon.png',
                    title: 'All Phones',
                    text: 'Total: 349',
                    color: kBlue,
                  ),
                ),
                Expanded(
                  child: DashboardContent(
                    iconPath: 'assets/icons/headphones_icon.png',
                    title: 'Accessories',
                    text: 'Total: 300',
                    color: Colors.pinkAccent,
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
                    text: 'Total: 8',
                    color: Colors.orangeAccent,
                  ),
                ),
                Expanded(
                  child: DashboardContent(
                    iconPath: 'assets/icons/dollar_icon.png',
                    title: 'Profit',
                    text: 'Total: 1999\$',
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
