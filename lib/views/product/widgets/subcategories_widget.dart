import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phone_shop/common/app_style.dart';
import 'package:phone_shop/common/reusable_text.dart';
import 'package:phone_shop/common/selection_bottom_sheet.dart';
import 'package:phone_shop/constants/constants.dart';
import 'package:phone_shop/controllers/category_controller.dart';
import 'package:phone_shop/controllers/subcategory_controller.dart';
import 'package:phone_shop/controllers/tab_nav_controller.dart';
import 'package:phone_shop/models/category_model.dart';

class SubcategoryWidget extends StatelessWidget {
  final void Function(CategoryModel selected)? onChanged;
  final subCategoryController = Get.find<SubCategoryController>();
  final categoryController = Get.find<CategoryController>();
  final tabNavController = Get.find<TabNavController>();

  SubcategoryWidget({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final currentIndex = tabNavController.currentIndex.value;

      // ✅ Decide which category type to use based on current tab
      final isPhoneTab = currentIndex == 0;
      final parent = isPhoneTab
          ? categoryController.categories.firstWhereOrNull(
              (c) => c.name.toLowerCase().contains('phone'),
            )
          : categoryController.categories.firstWhereOrNull(
              (c) => c.name.toLowerCase().contains('accessory'),
            );

      if (parent == null) {
        return const Text('Parent category not found');
      }

      // ✅ Load only subcategories of the right parent
      final subCategories =
          subCategoryController.subcategoriesByParent[parent.id] ?? [];

      if (subCategoryController.isLoading.value && subCategories.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (subCategories.isEmpty) {
        subCategoryController.fetchSubcategories(parent.id);
        return const Text('No subcategories available');
      }

      final selectedSubcatId = subCategoryController.selectedParentId.value;
      final selectedSubcatName = subCategories
              .firstWhereOrNull((c) => c.id == selectedSubcatId)
              ?.name ??
          subCategories.first.name;

      return Align(
        alignment: Alignment.topRight,
        child: GestureDetector(
          onTap: () => showSubcategoryPicker(context, parent.id, onChanged),
          child: Container(
            width: 120.w,
            height: 40.h,
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(width: 1, color: kGray)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 60.w,
                  child: ReusableText(
                    text: selectedSubcatName,
                    overflow: TextOverflow.ellipsis,
                    style: appStyle(12, kGray, FontWeight.normal),
                  ),
                ),
                Icon(Icons.keyboard_arrow_down, color: kDark, size: 18.r),
              ],
            ),
          ),
        ),
      );
    });
  }

  void showSubcategoryPicker(
    BuildContext context,
    String parentId,
    void Function(CategoryModel)? onChanged,
  ) {
    final items = subCategoryController.subcategoriesByParent[parentId] ?? [];

    SelectionBottomSheet.show<CategoryModel>(
      context: context,
      title: 'Select Subcategory',
      items: items,
      selectedId: subCategoryController.selectedParentId.value,
      getId: (c) => c.id,
      getLabel: (c) => c.name,
      onSelect: (selected) {
        subCategoryController.selectedParentId.value = selected.id;
        if (onChanged != null) onChanged(selected);
      },
    );
  }
}
