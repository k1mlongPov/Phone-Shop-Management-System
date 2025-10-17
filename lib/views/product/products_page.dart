import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phone_shop/common/custom_appbar.dart';
import 'package:phone_shop/common/custom_container.dart';
import 'package:phone_shop/constants/constants.dart';
import 'package:phone_shop/controllers/category_controller.dart';
import 'package:phone_shop/controllers/subcategory_controller.dart';
import 'package:phone_shop/controllers/switch_controller.dart';
import 'package:phone_shop/views/product/phones_accessories_switch.dart';
import 'package:phone_shop/views/product/widgets/product_category_widget.dart';

class ProductsPage extends StatelessWidget {
  ProductsPage({super.key});

  final switchController = Get.put(SwitchController());
  final categoryController = Get.put(CategoryController());
  final subcategoryController = Get.put(SubCategoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlue,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.h),
        child: const CustomAppbar(),
      ),
      body: CustomContainer(
        color: kWhite,
        containerContent: Column(
          children: [
            SizedBox(height: 10.h),
            TextFormField(),
            SizedBox(height: 10.h),
            PhonesAccessoriesSwitch(),
            SizedBox(height: 10.h),
            Obx(() {
              return ProductCategoryWidget(
                title:
                    switchController.isSwitch.value ? 'Phones' : 'Accessories',
              );
            }),
          ],
        ),
      ),
    );
  }
}
