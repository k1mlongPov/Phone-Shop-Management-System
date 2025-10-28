import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_shop/common/custom_button.dart';
import 'package:phone_shop/common/custom_textfield.dart';
import 'package:phone_shop/constants/constants.dart';
import 'package:phone_shop/controllers/subcategory_controller.dart';
import 'package:phone_shop/controllers/supplier_controller.dart';
import 'package:phone_shop/models/phone_model.dart';
import 'package:phone_shop/models/pricing_model.dart';
import 'package:phone_shop/models/variant_form_data.dart';
import 'package:phone_shop/views/product/widgets/confirm_submit_button.dart';
import 'package:phone_shop/views/product/widgets/image_picker_grid.dart';
import 'package:phone_shop/views/product/widgets/supplier_category_selector.dart';
import 'package:phone_shop/views/product/widgets/variant_form_widget.dart';

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
  final int lowStockThreshold;
  final double batteryHealth;
  final List<File> newImages;
  final List<String> existingImages;
  final List<VariantFormData> variants;

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
    required this.lowStockThreshold,
    required this.batteryHealth,
    required this.newImages,
    required this.existingImages,
    required this.variants,
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
  List<VariantFormData> variants = [];

  void _addVariant() {
    setState(() {
      variants.add(
        VariantFormData(
          storage: '',
          color: '',
          pricing: Pricing(purchasePrice: 0, sellingPrice: 0),
          stock: 0,
        ),
      );
    });

    // Delay for smooth scroll to the bottom (optional)
    Future.delayed(const Duration(milliseconds: 300), () {
      Scrollable.ensureVisible(
        // ignore: use_build_context_synchronously
        context,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _removeVariant(int index) {
    setState(() => variants.removeAt(index));
  }

  void _updateVariant(int index, VariantFormData updated) {
    setState(() => variants[index] = updated);
  }

  // Controllers
  late TextEditingController brandController;
  late TextEditingController modelController;
  late TextEditingController slugController;
  late TextEditingController purchaseController;
  late TextEditingController sellingController;
  late TextEditingController stockController;
  late TextEditingController osController;
  late TextEditingController chipsetController;
  final TextEditingController lowStockController = TextEditingController();
  final TextEditingController batteryHealthController = TextEditingController();

  List<File> newImages = [];
  List<String> existingImages = [];

  @override
  void initState() {
    super.initState();
    final phone = widget.initialPhone;

    // Pre-fill data
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
    lowStockController.text =
        widget.initialPhone?.lowStockThreshold.toString() ?? '5';
    batteryHealthController.text =
        widget.initialPhone?.batteryHealth?.toString() ?? '';
    existingImages = List<String>.from(phone?.images ?? []);

    // Supplier prefill
    supplierController.fetchSuppliers().then((_) {
      if (phone?.supplier != null) {
        supplierController.selectedSupplierId.value = phone!.supplier!.id;
      }
    });

    // Variants prefill
    if (phone?.variants != null && phone!.variants.isNotEmpty) {
      variants = phone.variants
          .map(
            (v) => VariantFormData(
              storage: v.storage,
              color: v.color,
              pricing: v.pricing,
              stock: v.stock,
            ),
          )
          .toList();
    }
  }

  @override
  void dispose() {
    brandController.dispose();
    modelController.dispose();
    slugController.dispose();
    purchaseController.dispose();
    sellingController.dispose();
    stockController.dispose();
    osController.dispose();
    chipsetController.dispose();
    lowStockController.dispose();
    batteryHealthController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final categoryId = subCategoryController.selectedParentId.value.isEmpty
        ? widget.initialPhone?.category.id ?? ''
        : subCategoryController.selectedParentId.value;

    if (categoryId.isEmpty) {
      Get.snackbar('Error', 'Please select a subcategory');
      return;
    }

    final supplierId = supplierController.selectedSupplierId.value;
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
      batteryHealth: double.tryParse(batteryHealthController.text.trim()) ?? 0,
      categoryId: categoryId,
      supplierId: supplierId,
      stock: stock,
      lowStockThreshold: int.tryParse(lowStockController.text.trim()) ?? 5,
      newImages: newImages,
      existingImages: existingImages,
      variants: variants,
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
                  onEditingComplete: () {
                    slugController.text =
                        '${brandController.text.toLowerCase()}-${modelController.text.toLowerCase()}'
                            .replaceAll(RegExp(r'\s+'), '-');
                  },
                ),
                SizedBox(height: 12.h),
                CustomTextWidget(
                  controller: slugController,
                  label: 'Slug (auto-generated)',
                  hintText: 'e.g. samsung-galaxy-s24',
                ),
                SizedBox(height: 12.h),
                // ✅ Supplier + Category selector
                SupplierCategorySelector(
                  supplierController: supplierController,
                  subCategoryController: subCategoryController,
                  initialItem: widget.initialPhone,
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextWidget(
                        controller: purchaseController,
                        label: 'Purchase Price',
                        keyBoardType: TextInputType.number,
                        validator: (v) =>
                            v!.isEmpty ? 'Purchase Price required' : null,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: CustomTextWidget(
                        controller: sellingController,
                        label: 'Selling Price',
                        keyBoardType: TextInputType.number,
                        validator: (v) =>
                            v!.isEmpty ? 'Selling Price required' : null,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                CustomTextWidget(
                  controller: stockController,
                  label: 'Stock',
                  keyBoardType: TextInputType.number,
                ),
                SizedBox(height: 12.h),
                CustomTextWidget(
                  controller: lowStockController,
                  label: 'Low Stock Threshold',
                  keyBoardType: TextInputType.number,
                ),
                SizedBox(height: 12.h),
                CustomTextWidget(
                  controller: batteryHealthController,
                  label: 'Battery Health (%)',
                  keyBoardType: TextInputType.number,
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

                ...variants.asMap().entries.map((entry) {
                  final index = entry.key;
                  final variant = entry.value;
                  return VariantFormWidget(
                    index: index,
                    variant: variant,
                    onRemove: _removeVariant,
                    onUpdate: _updateVariant,
                  );
                }),

                SizedBox(height: 8.h),
                CustomButton(
                  btnHeight: 40,
                  btnWidth: 120,
                  text: 'Add Variant',
                  btnColor: kBlue.withOpacity(0.6),
                  onTap: _addVariant,
                ),

                SizedBox(height: 16.h),

                // ✅ Image picker
                ImagePickerGrid(
                  existingImages: existingImages,
                  newImages: newImages,
                  onPick: (files) => setState(() => newImages.addAll(files)),
                  onRemoveExisting: (url) =>
                      setState(() => existingImages.remove(url)),
                  onRemoveNew: (file) => setState(() => newImages.remove(file)),
                ),

                SizedBox(height: 24.h),

                // ✅ Submit button
                ConfirmSubmitButton(
                  isEdit: widget.isEdit,
                  onConfirm: _handleSubmit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
