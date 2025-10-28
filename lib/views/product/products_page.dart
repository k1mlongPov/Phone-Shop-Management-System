import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_shop/common/app_style.dart';
import 'package:phone_shop/common/reusable_text.dart';
import 'package:phone_shop/constants/constants.dart';
import 'package:phone_shop/controllers/phone_controller.dart';
import 'package:phone_shop/controllers/accessory_controller.dart';
import 'package:phone_shop/controllers/category_controller.dart';
import 'package:phone_shop/controllers/subcategory_controller.dart';
import 'package:phone_shop/controllers/supplier_controller.dart';
import 'package:phone_shop/controllers/switch_controller.dart';
import 'package:phone_shop/controllers/tab_nav_controller.dart';
import 'package:phone_shop/views/product/add_accessory_screen.dart';
import 'package:phone_shop/views/product/add_phone_screen.dart';
import 'package:phone_shop/views/product/category_management_screen.dart';
import 'package:phone_shop/views/product/widgets/accessory_list_view.dart';
import 'package:phone_shop/views/product/widgets/add_category_screen.dart';
import 'package:phone_shop/views/product/widgets/add_supplier_screen.dart';
import 'package:phone_shop/views/product/widgets/phone_list_view.dart';
import 'package:phone_shop/views/product/widgets/search_and_filter_widget.dart';
import 'package:phone_shop/views/product/widgets/subcategories_widget.dart';
import 'package:phone_shop/views/product/supplier_management_screen.dart';

class ProductsPage extends StatelessWidget {
  ProductsPage({super.key});

  final switchController = Get.put(SwitchController());
  final phoneController = Get.put(PhoneController());
  final accessoryController = Get.put(AccessoryController());
  final categoryController = Get.put(CategoryController());
  final subcategoryController =
      Get.put(SubCategoryController(), permanent: true);
  final supplierController = Get.put(SupplierController());
  final tabNavController = Get.put(TabNavController());

  final sortOptions = const {
    '': 'Default',
    'name': 'Name',
    'price_asc': 'Price (Low → High)',
    'price_desc': 'Price (High → Low)',
    'stock_asc': 'Stock (Low → High)',
    'stock_desc': 'Stock (High → Low)',
    'latest': 'Newest',
    'oldest': 'Oldest',
  };
  final children = <Widget>[
    PhoneListView(),
    AccessoryListView(),
    Column(
      children: [
        Expanded(
          child: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                const TabBar(
                  labelColor: kBlue,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: kBlue,
                  tabs: [
                    Tab(text: 'Phone Subcategories'),
                    Tab(text: 'Accessory Subcategories'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      CategoryManagementScreen(type: 'phone'),
                      CategoryManagementScreen(type: 'accessory'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
    SupplierManagementScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        title: ReusableText(
          text: 'Product Management',
          style: appStyle(16, kWhite, FontWeight.w600),
        ),
        backgroundColor: kBlue,
        centerTitle: true,
        bottom: TabBar(
          labelStyle: appStyle(14, kDark, FontWeight.w600),
          padding: EdgeInsets.zero,
          controller: tabNavController.tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: kWhite.withOpacity(0.7),
          physics: const BouncingScrollPhysics(),
          tabAlignment: TabAlignment.center,
          tabs: const [
            Tab(text: 'Phones'),
            Tab(text: 'Accessories'),
            Tab(text: 'Categories'),
            Tab(text: 'Suppliers'),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(12.r),
        child: Obx(
          () {
            final index = tabNavController.currentIndex.value;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔍 Search + Sort
                if (index == 0)
                  SearchAndFilterWidget(
                    controller: phoneController,
                    sortOptions: sortOptions,
                  )
                else if (index == 1)
                  SearchAndFilterWidget(
                    controller: accessoryController,
                    sortOptions: sortOptions,
                  ),
                SizedBox(height: 10.h),

                // Subcategory Filter
                if (index == 0 || index == 1)
                  SubcategoryWidget(
                    onChanged: (selected) {
                      if (index == 0) {
                        phoneController.selectSubcategory(selected.id);
                        accessoryController.resetFilter();
                      } else if (index == 1) {
                        accessoryController.selectSubcategory(selected.id);
                        phoneController.resetFilter();
                      }
                    },
                  ),

                SizedBox(height: 10.h),
                Expanded(
                  child: TabBarView(
                    controller: tabNavController.tabController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: children,
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: Obx(
        () {
          final index = tabNavController.currentIndex.value;
          return FloatingActionButton(
            backgroundColor: kBlue.withOpacity(.85),
            onPressed: () {
              switch (index) {
                case 0:
                  Get.to(
                    () => AddPhoneScreen(),
                    fullscreenDialog: true,
                    preventDuplicates: false,
                  );
                  break;
                case 1:
                  Get.to(
                    () => AddAccessoryScreen(),
                    fullscreenDialog: true,
                    preventDuplicates: false,
                  );
                  break;
                case 2:
                  Get.to(
                    () => const AddCategoryScreen(),
                    fullscreenDialog: true,
                    preventDuplicates: false,
                  );
                  break;
                case 3:
                  Get.to(
                    () => const AddSupplierScreen(),
                    fullscreenDialog: true,
                    preventDuplicates: false,
                  );
                  break;
              }
            },
            child: const Icon(Icons.add, color: Colors.white),
          );
        },
      ),
    );
  }
}
