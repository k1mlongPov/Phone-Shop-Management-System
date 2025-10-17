import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_shop/controllers/subcategory_controller.dart';
import 'package:phone_shop/views/product/widgets/subcategories_list.dart';

class AccessoriesWidget extends StatelessWidget {
  final String parentId;
  AccessoriesWidget({super.key, required this.parentId});

  final SubCategoryController controller = Get.put(SubCategoryController());
  final RxString selectedSubId = ''.obs;

  @override
  Widget build(BuildContext context) {
    controller.fetchSubcategories(parentId);

    return Obx(
      () {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.subCategories.isEmpty) {
          return const Center(child: Text("No accessory subcategories"));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PhoneSubcategoryDropdown(
              onChanged: (selected) {
                Center(
                  child: Text(
                    "Showing products for ${controller.subCategories.firstWhere((e) => e.id == selectedSubId.value).name}",
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
