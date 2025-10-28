import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_shop/common/custom_textfield.dart';
import 'package:phone_shop/common/selection_bottom_sheet.dart';
import 'package:phone_shop/controllers/subcategory_controller.dart';
import 'package:phone_shop/controllers/supplier_controller.dart';
import 'package:phone_shop/models/category_model.dart';
import 'package:phone_shop/models/supplier_model.dart';

class SupplierCategorySelector extends StatelessWidget {
  final SupplierController supplierController;
  final SubCategoryController subCategoryController;
  final dynamic initialItem;

  const SupplierCategorySelector({
    super.key,
    required this.supplierController,
    required this.subCategoryController,
    this.initialItem,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Obx(() {
            final selectedSupplier =
                supplierController.suppliers.firstWhereOrNull(
              (s) => s.id == supplierController.selectedSupplierId.value,
            );

            return GestureDetector(
              onTap: () {
                SelectionBottomSheet.show<SupplierModel>(
                  context: context,
                  title: 'Select Supplier',
                  items: supplierController.suppliers,
                  selectedId: supplierController.selectedSupplierId.value,
                  getId: (s) => s.id,
                  getLabel: (s) => s.name,
                  onSelect: (s) =>
                      supplierController.selectedSupplierId.value = s.id,
                );
              },
              child: AbsorbPointer(
                child: CustomTextWidget(
                  controller: TextEditingController(
                    text: selectedSupplier?.name ??
                        initialItem?.supplier?.name ??
                        '',
                  ),
                  label: 'Supplier',
                  hintText: 'Select supplier',
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Please select supplier' : null,
                ),
              ),
            );
          }),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Obx(() {
            final selectedCategory = subCategoryController
                .subcategoriesByParent.values
                .expand((e) => e)
                .toList()
                .firstWhereOrNull((c) =>
                    c.id == subCategoryController.selectedParentId.value);

            return GestureDetector(
              onTap: () {
                SelectionBottomSheet.show<CategoryModel>(
                  context: context,
                  title: 'Select Subcategory',
                  items: subCategoryController.subcategoriesByParent.values
                      .expand((e) => e)
                      .toList(),
                  selectedId: subCategoryController.selectedParentId.value,
                  getId: (c) => c.id,
                  getLabel: (c) => c.name,
                  onSelect: (c) =>
                      subCategoryController.selectedParentId.value = c.id,
                );
              },
              child: AbsorbPointer(
                child: CustomTextWidget(
                  controller: TextEditingController(
                    text: selectedCategory?.name ??
                        initialItem?.category?.name ??
                        '',
                  ),
                  label: 'Subcategory',
                  hintText: 'Select category',
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Please select category' : null,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
