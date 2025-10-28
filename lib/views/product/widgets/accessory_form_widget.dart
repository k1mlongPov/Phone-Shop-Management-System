import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_shop/common/custom_button.dart';
import 'package:phone_shop/common/custom_textfield.dart';
import 'package:phone_shop/controllers/subcategory_controller.dart';
import 'package:phone_shop/controllers/supplier_controller.dart';
import 'package:phone_shop/models/accessory_model.dart';
import 'package:phone_shop/views/product/widgets/image_picker_grid.dart';
import 'package:phone_shop/views/product/widgets/supplier_category_selector.dart';

/// Data structure for form submission
class AccessoryFormData {
  final String name;
  final String type;
  final String? brand;
  final String? sku;
  final double purchasePrice;
  final double sellingPrice;
  final String categoryId;
  final String supplierId;
  final int stock;
  final int lowStockThreshold;
  final Map<String, dynamic> attributes;
  final List<String> compatibility;
  final List<File> newImages;
  final List<String> existingImages;

  AccessoryFormData({
    required this.name,
    required this.type,
    this.brand,
    this.sku,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.categoryId,
    required this.supplierId,
    required this.stock,
    required this.lowStockThreshold,
    required this.attributes,
    required this.compatibility,
    required this.newImages,
    required this.existingImages,
  });
}

/// Form widget for Add/Edit Accessory
class AccessoryFormWidget extends StatefulWidget {
  final AccessoryModel? initialAccessory;
  final bool isEdit;
  final Future<void> Function(AccessoryFormData data) onSubmit;

  const AccessoryFormWidget({
    super.key,
    this.initialAccessory,
    this.isEdit = false,
    required this.onSubmit,
  });

  @override
  State<AccessoryFormWidget> createState() => _AccessoryFormWidgetState();
}

class _AccessoryFormWidgetState extends State<AccessoryFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final subCategoryController = Get.find<SubCategoryController>();
  final supplierController = Get.find<SupplierController>();
  final picker = ImagePicker();

  // Controllers
  late TextEditingController nameController;
  late TextEditingController typeController;
  late TextEditingController brandController;
  late TextEditingController skuController;
  late TextEditingController purchaseController;
  late TextEditingController sellingController;
  late TextEditingController stockController;
  late TextEditingController lowStockController;
  late TextEditingController compatibilityController;

  List<File> newImages = [];
  List<String> existingImages = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    final acc = widget.initialAccessory;

    supplierController.fetchSuppliers().then((_) {
      if (acc?.supplier != null) {
        supplierController.selectedSupplierId.value = acc!.supplier!.id;
      }
    });

    nameController = TextEditingController(text: acc?.name ?? '');
    typeController = TextEditingController(text: acc?.type ?? '');
    brandController = TextEditingController(text: acc?.brand ?? '');
    skuController = TextEditingController(text: acc?.sku ?? '');
    purchaseController = TextEditingController(
        text: acc?.pricing.purchasePrice.toString() ?? '');
    sellingController =
        TextEditingController(text: acc?.pricing.sellingPrice.toString() ?? '');
    stockController = TextEditingController(text: acc?.stock.toString() ?? '');
    lowStockController =
        TextEditingController(text: acc?.lowStockThreshold.toString() ?? '10');
    compatibilityController =
        TextEditingController(text: acc?.compatibility?.join(', ') ?? '');
    existingImages = List<String>.from(acc?.images ?? []);
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final categoryId = subCategoryController.selectedParentId.value.isEmpty
        ? widget.initialAccessory?.category?.id ?? ''
        : subCategoryController.selectedParentId.value;

    final supplierId = supplierController.selectedSupplierId.value;

    if (categoryId.isEmpty) {
      Get.snackbar('Error', 'Please select a subcategory');
      return;
    }

    final purchasePrice = double.tryParse(purchaseController.text.trim()) ?? 0;
    final sellingPrice = double.tryParse(sellingController.text.trim()) ?? 0;
    final stock = int.tryParse(stockController.text.trim()) ?? 0;
    final lowStock = int.tryParse(lowStockController.text.trim()) ?? 10;

    final compatibility = compatibilityController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final data = AccessoryFormData(
      name: nameController.text.trim(),
      type: typeController.text.trim(),
      brand: brandController.text.trim().isEmpty
          ? null
          : brandController.text.trim(),
      sku: skuController.text.trim().isEmpty ? null : skuController.text.trim(),
      purchasePrice: purchasePrice,
      sellingPrice: sellingPrice,
      categoryId: categoryId,
      supplierId: supplierId,
      stock: stock,
      lowStockThreshold: lowStock,
      attributes: const {}, // could later expand to dynamic attributes form
      compatibility: compatibility,
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
                  controller: nameController,
                  label: 'Name',
                  hintText: 'e.g. Phone Case',
                  validator: (v) => v!.isEmpty ? 'Name required' : null,
                ),
                SizedBox(height: 12.h),
                CustomTextWidget(
                  controller: typeController,
                  label: 'Type',
                  hintText: 'e.g. Charger, Cable, Headset',
                  validator: (v) => v!.isEmpty ? 'Type required' : null,
                ),
                SizedBox(height: 12.h),
                CustomTextWidget(
                  controller: brandController,
                  label: 'Brand (optional)',
                  hintText: 'e.g. Baseus, Anker',
                ),
                SizedBox(height: 12.h),
                CustomTextWidget(
                  controller: skuController,
                  label: 'SKU (optional)',
                  hintText: 'e.g. SKU12345',
                ),
                SizedBox(height: 12.h),
                SupplierCategorySelector(
                  supplierController: supplierController,
                  subCategoryController: subCategoryController,
                  initialItem: widget.initialAccessory,
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
                Row(
                  children: [
                    Expanded(
                      child: CustomTextWidget(
                        controller: stockController,
                        label: 'Stock',
                        keyBoardType: TextInputType.number,
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: CustomTextWidget(
                        controller: lowStockController,
                        label: 'Low Stock Alert',
                        keyBoardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                CustomTextWidget(
                  controller: compatibilityController,
                  label: 'Compatibility (comma separated)',
                  hintText: 'e.g. iPhone, Samsung, Huawei',
                ),
                SizedBox(height: 16.h),
                ImagePickerGrid(
                  existingImages: existingImages,
                  newImages: newImages,
                  onPick: (files) => setState(() => newImages.addAll(files)),
                  onRemoveExisting: (url) =>
                      setState(() => existingImages.remove(url)),
                  onRemoveNew: (file) => setState(() => newImages.remove(file)),
                ),
                SizedBox(height: 24.h),
                CustomButton(
                  btnHeight: 46,
                  onTap: _handleSubmit,
                  text: widget.isEdit ? 'Update Accessory' : 'Add Accessory',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
