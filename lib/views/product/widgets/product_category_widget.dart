import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_shop/controllers/phone_controller.dart';
import 'package:phone_shop/controllers/subcategory_controller.dart';
import 'package:phone_shop/views/product/widgets/product_list_view.dart';
import 'package:phone_shop/views/product/widgets/subcategories_list.dart';

class ProductCategoryWidget extends StatelessWidget {
  final String title;
  const ProductCategoryWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final subCategoryController = Get.find<SubCategoryController>();
    final RxString selectedSubId = ''.obs;

    return Obx(
      () {
        if (subCategoryController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (subCategoryController.subCategories.isEmpty) {
          return Center(
            child: Text("No $title subcategories available"),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PhoneSubcategoryDropdown(
              onChanged: (selected) {
                final phoneController = Get.find<PhoneController>();
                phoneController.selectSubcategory(selected.id);
              },
            ),
            const SizedBox(height: 10),
            Obx(
              () {
                final selected = selectedSubId.value;
                final categoryList = subCategoryController.subCategories;

                return Center(
                  child: Text(
                    selected.isEmpty
                        ? "Showing all $title"
                        : "Showing ${categoryList.firstWhere((e) => e.id == selected).name} $title",
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            ProductListView(),
          ],
        );
      },
    );
  }
}
