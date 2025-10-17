import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_shop/controllers/subcategory_controller.dart';
import 'package:phone_shop/views/product/widgets/subcategories_list.dart';

class PhonesWidget extends StatelessWidget {
  final String parentId;
  PhonesWidget({super.key, required this.parentId});

  final SubCategoryController controller = Get.find<SubCategoryController>();
  final RxString selectedSubId = ''.obs;

  @override
  Widget build(BuildContext context) {
    // Fetch only once, not on every rebuild
    if (controller.subCategories.isEmpty) {
      controller.fetchSubcategories(parentId);
    }

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.subCategories.isEmpty) {
        return const Center(child: Text("No phone subcategories"));
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PhoneSubcategoryDropdown(
            onChanged: (selected) {
              selectedSubId.value = selected.id;
            },
          ),
          const SizedBox(height: 10),
          Obx(() {
            final selected = selectedSubId.value;
            return Center(
              child: Text(
                selected.isEmpty
                    ? "Showing all products"
                    : "Showing products for ${controller.subCategories.firstWhere((e) => e.id == selected).name}",
              ),
            );
          }),
        ],
      );
    });
  }
}
