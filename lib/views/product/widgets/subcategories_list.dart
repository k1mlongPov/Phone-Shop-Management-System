import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phone_shop/controllers/subcategory_controller.dart';
import 'package:phone_shop/models/category_model.dart';

class PhoneSubcategoryDropdown extends StatelessWidget {
  final void Function(CategoryModel selected)? onChanged;

  const PhoneSubcategoryDropdown({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final SubCategoryController subCategoryController =
        Get.find<SubCategoryController>();

    return Obx(
      () {
        if (subCategoryController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final subCategories = subCategoryController.subCategories;
        if (subCategories.isEmpty) {
          return const Text('No subcategories available');
        }

        return Align(
          alignment: AlignmentDirectional.topStart,
          child: Container(
            margin: EdgeInsets.only(left: 20.w),
            width: 120.w,
            height: 70.h,
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
              ),
              // Ensure current value is valid; fallback to first item (usually 'All')
              value: subCategoryController.selectedParentId.value.isNotEmpty &&
                      subCategories.any((e) =>
                          e.id == subCategoryController.selectedParentId.value)
                  ? subCategoryController.selectedParentId.value
                  : subCategories.first.id,

              items: subCategories.map((subcategory) {
                return DropdownMenuItem<String>(
                  value: subcategory.id,
                  child: Text(subcategory.name),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  subCategoryController.selectedParentId.value = value;
                  final selected =
                      subCategories.firstWhere((e) => e.id == value);
                  if (onChanged != null) onChanged!(selected);
                }
              },
            ),
          ),
        );
      },
    );
  }
}
