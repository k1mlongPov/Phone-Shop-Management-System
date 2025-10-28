import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:phone_shop/common/custom_textfield.dart';
import 'package:phone_shop/common/reusable_text.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';
import 'package:phone_shop/constants/constants.dart';
import 'package:phone_shop/common/app_style.dart';
import 'package:phone_shop/controllers/supplier_controller.dart';
import 'package:phone_shop/models/supplier_model.dart';

class SupplierManagementScreen extends StatelessWidget {
  SupplierManagementScreen({super.key});

  final controller = Get.find<SupplierController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildShimmerList();
      }

      if (controller.suppliers.isEmpty) {
        return const Center(child: Text("No suppliers found"));
      }

      final lastUpdated = controller.suppliers.isNotEmpty
          ? DateFormat('dd MMM yyyy').format(
              controller.suppliers
                  .map((s) => s.updatedAt ?? DateTime.now())
                  .reduce((a, b) => a.isAfter(b) ? a : b),
            )
          : 'N/A';

      return RefreshIndicator(
        onRefresh: controller.fetchSuppliers,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(top: 12.h),
          children: [
            _buildSummaryCard(
              count: controller.suppliers.length,
              lastUpdated: lastUpdated,
              onRefresh: controller.fetchSuppliers,
            ),
            const SizedBox(height: 10),
            ...controller.suppliers
                .map((supplier) => _buildSupplierTile(supplier)),
          ],
        ),
      );
    });
  }

  /// ✅ Summary Card (like in Category Screen)
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
            Icon(Icons.store, color: kBlue, size: 34.r),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Suppliers',
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

  /// ✅ Supplier ListTile (with card + slidable)
  Widget _buildSupplierTile(SupplierModel supplier) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
      child: Slidable(
        key: ValueKey(supplier.id),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (_) async {
                // 🧩 Delay ensures the Slidable animation completes first
                await Future.delayed(const Duration(milliseconds: 200));
                _showEditDialog(supplier);
              },
              backgroundColor: kBlue.withOpacity(.8),
              foregroundColor: Colors.white,
              icon: Icons.edit,
            ),
            SlidableAction(
              onPressed: (_) async {
                await Future.delayed(const Duration(milliseconds: 200));
                controller.deleteSupplier(supplier.id);
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
            ),
          ],
        ),
        child: Container(
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
            leading: CircleAvatar(
              radius: 18.r,
              backgroundColor: supplier.active ? Colors.green : Colors.red,
              child: const Icon(Icons.person, color: Colors.white, size: 20),
            ),
            title: Text(
              supplier.name,
              style: appStyle(14, kDark, FontWeight.w600),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (supplier.phone != null && supplier.phone!.isNotEmpty)
                  Text('📞 ${supplier.phone!}',
                      style: appStyle(12, Colors.grey, FontWeight.normal)),
                if (supplier.email != null && supplier.email!.isNotEmpty)
                  Text('✉️ ${supplier.email!}',
                      style: appStyle(12, Colors.grey, FontWeight.normal)),
                Text(
                  supplier.active ? 'Active' : 'Inactive',
                  style: appStyle(
                    12,
                    supplier.active ? Colors.green : Colors.red,
                    FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ✅ Shimmer Loader
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
            height: 70.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ),
      ),
    );
  }

  /// ✅ Edit Supplier Dialog
  Future<void> _showEditDialog(SupplierModel supplier) async {
    final nameCtrl = TextEditingController(text: supplier.name);
    final contactNameCtrl =
        TextEditingController(text: supplier.contactName ?? '');
    final phoneCtrl = TextEditingController(text: supplier.phone ?? '');
    final emailCtrl = TextEditingController(text: supplier.email ?? '');
    final isActive = RxBool(supplier.active);

    await Get.generalDialog(
      barrierLabel: 'Edit Supplier Dialog',
      barrierDismissible: true,
      pageBuilder: (_, __, ___) {
        return GestureDetector(
          onTap: () => FocusScope.of(Get.context!)
              .unfocus(), // dismiss keyboard on tap outside
          child: Align(
            alignment: Alignment.center,
            child: Padding(
              // ensures dialog stays above keyboard
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(Get.context!).viewInsets.bottom,
                left: 16.w,
                right: 16.w,
              ),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: 500.h, // keep it 85% of screen height max
                    maxWidth: width * .8,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 14.h, horizontal: 16.w),
                        child: Text(
                          'Edit Supplier',
                          style: appStyle(18, kDark, FontWeight.w600),
                        ),
                      ),
                      const Divider(height: 1, thickness: 1),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.all(16.r),
                          child: Column(
                            children: [
                              CustomTextWidget(
                                controller: nameCtrl,
                                label: "Supplier Name",
                                hintText: "e.g. TechWorld Distributors",
                                validator: (v) => v == null || v.isEmpty
                                    ? 'Supplier name required'
                                    : null,
                              ),
                              SizedBox(height: 16.h),
                              CustomTextWidget(
                                controller: contactNameCtrl,
                                label: "Contact Name",
                                hintText: "e.g. San Vibol",
                              ),
                              SizedBox(height: 16.h),
                              CustomTextWidget(
                                controller: phoneCtrl,
                                label: "Phone number",
                                hintText: "e.g. +85512345678",
                              ),
                              SizedBox(height: 16.h),
                              CustomTextWidget(
                                controller: emailCtrl,
                                label: "Email",
                                hintText: "e.g. abc@gmail.com",
                              ),
                              SizedBox(height: 10.h),
                              Obx(
                                () => SwitchListTile(
                                  contentPadding: EdgeInsets.zero,
                                  activeColor: kWhite,
                                  activeTrackColor: kBlue,
                                  value: isActive.value,
                                  title: ReusableText(
                                    text: 'Active',
                                    style: appStyle(14, kDark, FontWeight.w400),
                                  ),
                                  onChanged: (val) => isActive.value = val,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(height: 1, thickness: 1),
                      Padding(
                        padding: EdgeInsets.all(12.r),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => Get.back(),
                              child: Text(
                                'Cancel',
                                style: appStyle(14, kDark, FontWeight.w500),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kBlue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.r),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24.w,
                                  vertical: 10.h,
                                ),
                              ),
                              onPressed: () async {
                                final success = await controller.updateSupplier(
                                  id: supplier.id,
                                  name: nameCtrl.text,
                                  contactName: contactNameCtrl.text,
                                  phone: phoneCtrl.text,
                                  email: emailCtrl.text,
                                  active: isActive.value,
                                );
                                if (success) {
                                  Future.delayed(
                                    const Duration(milliseconds: 300),
                                    () => Get.back(closeOverlays: true),
                                  );
                                }
                              },
                              child: Text(
                                'Save',
                                style: appStyle(14, kWhite, FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
