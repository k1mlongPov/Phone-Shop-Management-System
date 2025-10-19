import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phone_shop/common/app_style.dart';
import 'package:phone_shop/common/custom_appbar.dart';
import 'package:phone_shop/constants/constants.dart';
import 'package:phone_shop/controllers/accessory_controller.dart';
import 'package:phone_shop/controllers/base_product_controller.dart';
import 'package:phone_shop/controllers/category_controller.dart';
import 'package:phone_shop/controllers/phone_controller.dart';
import 'package:phone_shop/controllers/subcategory_controller.dart';
import 'package:phone_shop/controllers/switch_controller.dart';
import 'package:phone_shop/views/product/add_phone_screen.dart';
import 'package:phone_shop/views/product/phones_accessories_switch.dart';
import 'package:phone_shop/views/product/widgets/product_category_widget.dart';
import 'package:phone_shop/views/product/widgets/search_and_filter_widget.dart';

class ProductsPage extends StatelessWidget {
  ProductsPage({super.key});

  final switchController = Get.put(SwitchController());
  final categoryController = Get.put(CategoryController());
  final subcategoryController = Get.put(SubCategoryController());
  final phoneController = Get.put(PhoneController());
  final accessoryController = Get.put(AccessoryController());

  final sortOptions = {
    '': 'Default',
    'name': 'Name',
    'price_asc': 'Price (Low → High)',
    'price_desc': 'Price (High → Low)',
    'stock_asc': 'Stock (Low → High)',
    'stock_desc': 'Stock (High → Low)',
    'latest': 'Newest',
    'oldest': 'Oldest',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.h),
        child: const CustomAppbar(),
      ),
      body: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(10),
        children: [
          SizedBox(height: 10.h),
          Obx(() {
            final BaseProductController<dynamic> controller =
                switchController.isSwitch.value
                    ? phoneController
                    : accessoryController;

            return SearchAndFilterWidget(
              controller: controller,
              sortOptions: sortOptions,
            );
          }),
          SizedBox(height: 10.h),
          PhonesAccessoriesSwitch(),
          SizedBox(height: 10.h),
          Obx(
            () {
              return ProductCategoryWidget(
                title:
                    switchController.isSwitch.value ? 'Phones' : 'Accessories',
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kBlue.withOpacity(.7),
        elevation: 0,
        splashColor: kBlue,
        onPressed: () => _showAddOptions(context),
        child: Icon(
          Icons.add_outlined,
          color: kWhite,
          size: 22.r,
        ),
      ),
    );
  }

  void _showAddOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: kWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SizedBox(
          height: .4.sh,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40.w,
                  height: 4.h,
                  margin: EdgeInsets.only(bottom: 10.h),
                  decoration: BoxDecoration(
                    color: kGray.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                Text(
                  "Add Options",
                  style: appStyle(14, kDark, FontWeight.bold),
                ),
                SizedBox(height: 10.h),
                const Divider(),
                _buildBottomSheetItem(
                  icon: Icons.phone_android_outlined,
                  text: "Add Phone",
                  color: kBlue,
                  onTap: () {
                    Navigator.pop(context);
                    Get.to(() => const AddPhoneScreen());
                    debugPrint("Add Phone tapped");
                  },
                ),
                _buildBottomSheetItem(
                  icon: Icons.headphones_outlined,
                  text: "Add Accessory",
                  color: Colors.green,
                  onTap: () {
                    Navigator.pop(context);
                    debugPrint("Add Accessory tapped");
                  },
                ),
                _buildBottomSheetItem(
                  icon: Icons.category_outlined,
                  text: "Manage Category",
                  color: Colors.orange,
                  onTap: () {
                    Navigator.pop(context);
                    debugPrint("Manage Category tapped");
                  },
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomSheetItem({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.15),
        child: Icon(icon, color: color),
      ),
      title: Text(
        text,
        style: appStyle(13, kDark, FontWeight.w600),
      ),
      onTap: onTap,
    );
  }
}
