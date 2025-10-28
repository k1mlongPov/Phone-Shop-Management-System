import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:phone_shop/common/app_style.dart';
import 'package:phone_shop/common/custom_textfield.dart';
import 'package:phone_shop/common/show_confirm_dialog.dart';
import 'package:phone_shop/constants/constants.dart';
import 'package:phone_shop/controllers/category_controller.dart';
import 'package:phone_shop/controllers/subcategory_controller.dart';
import 'package:phone_shop/models/category_model.dart';
import 'package:shimmer/shimmer.dart';

class CategoryManagementScreen extends StatelessWidget {
  final String type; // "phone" or "accessory"
  CategoryManagementScreen({super.key, required this.type});

  final categoryController = Get.find<CategoryController>();
  final subCategoryController = Get.find<SubCategoryController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final parent = categoryController.categories.firstWhereOrNull(
          (c) => c.name.toLowerCase().contains(type.toLowerCase()),
        );

        if (parent == null) {
          return const Center(child: Text('Parent category not found'));
        }

        final subcats = subCategoryController.subcategoriesByParent[parent.id];
        if (subcats == null) {
          subCategoryController.fetchSubcategories(parent.id);
          return _buildShimmerList();
        }

        if (subCategoryController.isLoading.value) {
          return _buildShimmerList();
        }

        final visibleSubs = subcats.where((s) => s.id.isNotEmpty).toList();
        final lastUpdated = parent.updatedAt != null
            ? DateFormat('dd MMM yyyy').format(parent.updatedAt!)
            : 'N/A';

        return RefreshIndicator(
          backgroundColor: kWhite,
          color: kBlue,
          onRefresh: () =>
              subCategoryController.refetchSubcategories(parent.id),
          child: ListView(
            padding: EdgeInsets.only(top: 12.h),
            children: [
              _buildSummaryCard(
                count: visibleSubs.length,
                lastUpdated: lastUpdated,
                onRefresh: () =>
                    subCategoryController.refetchSubcategories(parent.id),
              ),
              const SizedBox(height: 10),
              if (visibleSubs.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'No subcategories found',
                      style: appStyle(13, Colors.grey, FontWeight.w500),
                    ),
                  ),
                )
              else
                ...visibleSubs
                    .map((sub) => _buildSubcategoryTile(sub, context)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 5,
      padding: EdgeInsets.all(12.r),
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.symmetric(vertical: 6.h),
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 55.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required int count,
    required String lastUpdated,
    required VoidCallback onRefresh,
  }) {
    return Card(
      color: kWhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(14.r),
        child: Row(
          children: [
            Icon(
              type == 'phone' ? Icons.smartphone : Icons.headphones,
              color: kBlue,
              size: 34.r,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${type.capitalizeFirst} Subcategories',
                      style: appStyle(14, kDark, FontWeight.w600)),
                  SizedBox(height: 4.h),
                  Text(
                    'Total: $count • Last updated: $lastUpdated',
                    style: appStyle(12, Colors.grey, FontWeight.normal),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh, color: kBlue),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubcategoryTile(CategoryModel sub, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
      child: Slidable(
        key: ValueKey(sub.id),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => _showEditDialog(sub),
              backgroundColor: kBlue.withOpacity(.8),
              foregroundColor: Colors.white,
              icon: Icons.edit,
            ),
            SlidableAction(
              onPressed: (_) {
                showConfirmDialog(
                  context,
                  title: 'Delete Category',
                  message: 'Do you want to delete this category?',
                  confirmText: 'Delete',
                  confirmColor: Colors.red,
                  onConfirm: () =>
                      subCategoryController.deleteSubcategory(sub.id),
                );
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
            ),
          ],
        ),
        child: Container(
          height: 55.h,
          decoration: BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ListTile(
            leading: Icon(Icons.category_outlined, color: kBlue, size: 26.r),
            title: Text(
              sub.name,
              style: appStyle(14, kDark, FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showEditDialog(CategoryModel sub) async {
    final nameController = TextEditingController(text: sub.name);

    await Get.defaultDialog(
      title: 'Edit Subcategory',
      titleStyle: appStyle(18, kDark, FontWeight.w600),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: CustomTextWidget(
          controller: nameController,
          label: 'Subcategory Name',
        ),
      ),
      confirm: Container(
        width: 80.w,
        height: 35.h,
        decoration: BoxDecoration(
          color: kBlue,
          borderRadius: BorderRadius.circular(25.r),
        ),
        child: TextButton(
          onPressed: () async {
            final newName = nameController.text.trim();
            if (newName.isNotEmpty && newName != sub.name) {
              final success = await subCategoryController.updateSubcategory(
                  sub.id, newName);

              if (success) {
                Get.back(closeOverlays: true);
                Future.delayed(
                  const Duration(milliseconds: 300),
                  () {
                    Get.snackbar('Success', 'Subcategory added successfully');
                  },
                );
              }
            }
          },
          child: Text(
            'Save',
            style: appStyle(14, kWhite, FontWeight.w500),
          ),
        ),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: Text(
          'Cancel',
          style: appStyle(14, kDark, FontWeight.w500),
        ),
      ),
    );
  }
}
