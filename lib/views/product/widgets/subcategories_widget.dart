import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phone_shop/common/app_style.dart';
import 'package:phone_shop/common/reusable_text.dart';
import 'package:phone_shop/constants/constants.dart';
import 'package:phone_shop/controllers/subcategory_controller.dart';
import 'package:phone_shop/models/category_model.dart';

class SubcategoryWidget extends StatelessWidget {
  final void Function(CategoryModel selected)? onChanged;

  const SubcategoryWidget({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final SubCategoryController subCategoryController =
        Get.find<SubCategoryController>();

    return Obx(
      () {
        final subCategories = subCategoryController.subCategories;
        final selectedId = subCategoryController.selectedParentId.value;

        if (subCategoryController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (subCategories.isEmpty) {
          return const Text('No subcategories available');
        }

        final selectedName = subCategories.isEmpty
            ? ''
            : subCategories.firstWhereOrNull((c) => c.id == selectedId)?.name ??
                subCategories.first.name;

        return Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
            onTap: () => _showSubcategorySheet(
              context,
              subCategories,
              subCategoryController,
            ),
            child: Container(
              width: 120.w,
              height: 40.h,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1, color: kGray),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 60.w,
                    child: ReusableText(
                      text: selectedName,
                      overflow: TextOverflow.ellipsis,
                      style: appStyle(12, kGray, FontWeight.normal),
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: kDark,
                    size: 18.r,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showSubcategorySheet(
    BuildContext context,
    List<CategoryModel> subCategories,
    SubCategoryController subCategoryController,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: .5.sh,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
            child: Column(
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
                Container(
                  height: 40.h,
                  alignment: Alignment.center,
                  child: Text(
                    'Select Subcategory',
                    style: appStyle(14, kDark, FontWeight.bold),
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.separated(
                    itemCount: subCategories.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final sub = subCategories[index];
                      return ListTile(
                        title: Text(
                          sub.name,
                          style: appStyle(
                            13,
                            kDark,
                            sub.id ==
                                    subCategoryController.selectedParentId.value
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        trailing: sub.id ==
                                subCategoryController.selectedParentId.value
                            ? const Icon(Icons.check, color: kBlue)
                            : null,
                        onTap: () {
                          subCategoryController.selectedParentId.value = sub.id;
                          if (onChanged != null) onChanged!(sub);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
