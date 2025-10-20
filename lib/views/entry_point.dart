import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_shop/common/app_style.dart';
import 'package:phone_shop/constants/constants.dart';
import 'package:phone_shop/controllers/tap_index_controller.dart';
import 'package:phone_shop/views/category/categories_page.dart';
import 'package:phone_shop/views/dashboard/dashboard_page.dart';
import 'package:phone_shop/views/product/products_page.dart';
import 'package:phone_shop/views/profit/profit_reports_page.dart';
import 'package:phone_shop/views/setting/settings_page.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});
  final List<Widget> pageList = [
    const DashboardPage(),
    ProductsPage(),
    const CategoriesPage(),
    const ProfitReportsPage(),
    const SettingsPage(),
  ];
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TapIndexController());
    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: pageList,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeTab,
          selectedItemColor: kWhite,
          unselectedItemColor: kGray,
          backgroundColor: kBlue,
          selectedLabelStyle: appStyle(12, kWhite, FontWeight.w600),
          elevation: 0,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.smartphone),
              label: 'Products',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: 'Categories',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Profit',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
