import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_shop/controllers/accessory_controller.dart';
import 'package:phone_shop/controllers/phone_controller.dart';
import 'package:phone_shop/controllers/subcategory_controller.dart';
import 'package:phone_shop/views/product/widgets/accessory_list_view.dart';
import 'package:phone_shop/views/product/widgets/phone_list_view.dart';
import 'package:phone_shop/views/product/widgets/subcategories_widget.dart';

class ProductCategoryWidget extends StatelessWidget {
  final String title;
  const ProductCategoryWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final subCategoryController = Get.find<SubCategoryController>();

    return Obx(
      () {
        if (subCategoryController.subCategories.isEmpty) {
          return Center(
            child: Text("No $title subcategories available"),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SubcategoryWidget(
              onChanged: (selected) {
                final phoneController = Get.find<PhoneController>();
                phoneController.selectSubcategory(selected.id);
                final accessoryController = Get.find<AccessoryController>();
                accessoryController.selectSubcategory(selected.id);
              },
            ),
            const SizedBox(height: 10),
            title == 'Phones' ? PhoneListView() : AccessoryListView(),
          ],
        );
      },
    );
  }
}
