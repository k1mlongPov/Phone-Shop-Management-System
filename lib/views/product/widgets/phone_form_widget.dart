import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_shop/common/app_style.dart';
import 'package:phone_shop/common/custom_button.dart';
import 'package:phone_shop/common/custom_textfield.dart';
import 'package:phone_shop/common/reusable_text.dart';
import 'package:phone_shop/common/show_confirm_dialog.dart';
import 'package:phone_shop/constants/constants.dart';
import 'package:phone_shop/controllers/subcategory_controller.dart';
import 'package:phone_shop/controllers/supplier_controller.dart';
import 'package:phone_shop/models/phone_model.dart';

class PhoneFormData {
  final String brand;
  final String model;
  final String slug;
  final double purchasePrice;
  final double sellingPrice;
  final String os;
  final String chipset;
  final String categoryId;
  final String supplierId;
  final int stock;
  final List<File> newImages;
  final List<String> existingImages;

  PhoneFormData({
    required this.brand,
    required this.model,
    required this.slug,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.os,
    required this.chipset,
    required this.categoryId,
    required this.supplierId,
    required this.stock,
    required this.newImages,
    required this.existingImages,
  });
}

class PhoneFormWidget extends StatefulWidget {
  final PhoneModel? initialPhone;
  final bool isEdit;
  final Future<void> Function(PhoneFormData data) onSubmit;

  const PhoneFormWidget({
    super.key,
    this.initialPhone,
    this.isEdit = false,
    required this.onSubmit,
  });

  @override
  State<PhoneFormWidget> createState() => _PhoneFormWidgetState();
}

class _PhoneFormWidgetState extends State<PhoneFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final subCategoryController = Get.find<SubCategoryController>();
  final supplierController = Get.find<SupplierController>();
  final picker = ImagePicker();

  // Controllers
  late TextEditingController brandController;
  late TextEditingController modelController;
  late TextEditingController slugController;
  late TextEditingController purchaseController;
  late TextEditingController sellingController;
  late TextEditingController stockController;
  late TextEditingController osController;
  late TextEditingController chipsetController;

  List<File> newImages = [];
  List<String> existingImages = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    final supplierController = Get.find<SupplierController>();
    final phone = widget.initialPhone;

    supplierController.fetchSuppliers().then((_) {
      if (phone?.supplier != null) {
        supplierController.selectedSupplierId.value = phone!.supplier!.id;
      }
    });
    brandController = TextEditingController(text: phone?.brand ?? '');
    modelController = TextEditingController(text: phone?.model ?? '');
    slugController = TextEditingController(text: phone?.slug ?? '');
    purchaseController = TextEditingController(
        text: phone?.pricing.purchasePrice.toString() ?? '');
    sellingController = TextEditingController(
        text: phone?.pricing.sellingPrice.toString() ?? '');
    stockController =
        TextEditingController(text: phone?.stock.toString() ?? '');
    osController = TextEditingController(text: phone?.specs.os ?? '');
    chipsetController = TextEditingController(text: phone?.specs.chipset ?? '');
    existingImages = List<String>.from(phone?.images ?? []);
  }

  Future<void> _pickImages() async {
    final picked = await picker.pickMultiImage(imageQuality: 75);
    if (picked.isNotEmpty) {
      setState(() {
        newImages = picked.map((x) => File(x.path)).toList();
      });
    }
  }

  void _autoGenerateSlug() {
    final brand = brandController.text.trim();
    final model = modelController.text.trim();
    if (brand.isNotEmpty && model.isNotEmpty) {
      slugController.text = '${brand.toLowerCase()}-${model.toLowerCase()}'
          .replaceAll(RegExp(r'\s+'), '-');
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final categoryId = subCategoryController.selectedParentId.value.isEmpty
        ? widget.initialPhone?.category.id ?? ''
        : subCategoryController.selectedParentId.value;
    final supplierId = supplierController.selectedSupplierId.value;

    if (categoryId.isEmpty) {
      Get.snackbar('Error', 'Please select a subcategory');
      return;
    }

    final purchasePrice = double.tryParse(purchaseController.text.trim()) ?? 0;
    final sellingPrice = double.tryParse(sellingController.text.trim()) ?? 0;
    final stock = int.tryParse(stockController.text.trim()) ?? 0;

    final data = PhoneFormData(
      brand: brandController.text.trim(),
      model: modelController.text.trim(),
      slug: slugController.text.trim(),
      purchasePrice: purchasePrice,
      sellingPrice: sellingPrice,
      os: osController.text.trim(),
      chipset: chipsetController.text.trim(),
      categoryId: categoryId,
      supplierId: supplierId,
      stock: stock,
      newImages: newImages,
      existingImages: existingImages,
    );

    await widget.onSubmit(data);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextWidget(
                  controller: brandController,
                  label: 'Brand',
                  hintText: 'e.g. Samsung',
                  validator: (v) => v!.isEmpty ? 'Brand required' : null,
                ),
                SizedBox(height: 12.h),
                CustomTextWidget(
                  controller: modelController,
                  label: 'Model',
                  hintText: 'e.g. Galaxy S24',
                  validator: (v) => v!.isEmpty ? 'Model required' : null,
                  onEditingComplete: _autoGenerateSlug,
                ),
                SizedBox(height: 12.h),
                CustomTextWidget(
                  controller: slugController,
                  label: 'Slug (auto-generated)',
                  hintText: 'e.g. samsung-galaxy-s24',
                  validator: (v) => v!.isEmpty ? 'Slug required' : null,
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: Obx(
                        () {
                          final suppliers = supplierController.suppliers;

                          final selectedValue = supplierController
                                  .selectedSupplierId.value.isNotEmpty
                              ? supplierController.selectedSupplierId.value
                              : widget.initialPhone?.supplier?.id;

                          return DropdownButtonFormField<String>(
                            value: selectedValue != null &&
                                    suppliers.any((s) => s.id == selectedValue)
                                ? selectedValue
                                : null,
                            items: suppliers
                                .map(
                                  (s) => DropdownMenuItem(
                                    value: s.id,
                                    child: ReusableText(
                                      text: s.name,
                                      style: appStyle(
                                          12, kDark, FontWeight.normal),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) => supplierController
                                .selectedSupplierId.value = v ?? '',
                            decoration: InputDecoration(
                              labelText: 'Supplier',
                              labelStyle:
                                  appStyle(12, kDark, FontWeight.normal),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide:
                                    const BorderSide(width: 1, color: kGray),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide:
                                    const BorderSide(width: 1, color: kGray),
                              ),
                            ),
                            validator: (v) => v == null || v.isEmpty
                                ? 'Select a supplier'
                                : null,
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Obx(() {
                        final subCats = subCategoryController.subCategories;
                        if (subCategoryController.isLoading.value) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (subCats.isEmpty) {
                          return const Text('No subcategories found');
                        }

                        return DropdownButtonFormField<String>(
                          value: subCategoryController
                                  .selectedParentId.value.isEmpty
                              ? widget.initialPhone?.category.id
                              : subCategoryController.selectedParentId.value,
                          items: subCats
                              .map(
                                (c) => DropdownMenuItem(
                                  value: c.id,
                                  child: ReusableText(
                                    text: c.name,
                                    style:
                                        appStyle(12, kDark, FontWeight.normal),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (v) => subCategoryController
                              .selectedParentId.value = v ?? '',
                          decoration: InputDecoration(
                            labelText: 'Subcategory',
                            labelStyle: appStyle(12, kDark, FontWeight.normal),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: const BorderSide(
                                width: 1,
                                color: kGray,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: const BorderSide(
                                width: 1,
                                color: kGray,
                              ),
                            ),
                          ),
                          validator: (v) => v == null || v.isEmpty
                              ? 'Select a subcategory'
                              : null,
                        );
                      }),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextWidget(
                        controller: purchaseController,
                        label: 'Purchase Price',
                        keyBoardType: TextInputType.number,
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: CustomTextWidget(
                        controller: sellingController,
                        label: 'Selling Price',
                        keyBoardType: TextInputType.number,
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                CustomTextWidget(
                  controller: stockController,
                  label: 'Stock',
                  keyBoardType: TextInputType.number,
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                SizedBox(height: 12.h),
                CustomTextWidget(
                  controller: osController,
                  label: 'Operating System',
                  hintText: 'e.g. Android 14',
                ),
                SizedBox(height: 12.h),
                CustomTextWidget(
                  controller: chipsetController,
                  label: 'Chipset',
                  hintText: 'e.g. Snapdragon 8 Gen 3',
                ),
                SizedBox(height: 16.h),
                Text(
                  'Images',
                  style: appStyle(14, kDark, FontWeight.w600),
                ),
                SizedBox(height: 8.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: [
                    // Existing images
                    ...existingImages.map((url) => Stack(
                          alignment: Alignment.topRight,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: Image.network(
                                url,
                                width: 80.w,
                                height: 80.w,
                                fit: BoxFit.cover,
                              ),
                            ),
                            GestureDetector(
                              onTap: () =>
                                  setState(() => existingImages.remove(url)),
                              child: Container(
                                padding: EdgeInsets.all(4.w),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: const Icon(Icons.close,
                                    color: Colors.white, size: 16),
                              ),
                            ),
                          ],
                        )),
                    // New images
                    ...newImages.map((file) => Stack(
                          alignment: Alignment.topRight,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: Image.file(
                                file,
                                width: 80.w,
                                height: 80.w,
                                fit: BoxFit.cover,
                              ),
                            ),
                            GestureDetector(
                              onTap: () =>
                                  setState(() => newImages.remove(file)),
                              child: Container(
                                padding: EdgeInsets.all(4.w),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: const Icon(Icons.close,
                                    color: Colors.white, size: 16),
                              ),
                            ),
                          ],
                        )),
                    GestureDetector(
                      onTap: _pickImages,
                      child: Container(
                        width: 80.w,
                        height: 80.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: kGray),
                        ),
                        child: const Icon(Icons.add_a_photo_outlined),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                CustomButton(
                  btnHeight: 46,
                  onTap: () {
                    showConfirmDialog(
                      context,
                      title: 'Update Phone',
                      message: 'Are you sure to update this phone?',
                      confirmText: 'Update',
                      confirmColor: kBlue.withOpacity(.8),
                      onConfirm: _handleSubmit,
                    );
                  },
                  text: widget.isEdit ? 'Update Phone' : 'Add Phone',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
