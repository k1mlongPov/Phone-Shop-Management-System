// lib/screens/add_phone_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_shop/common/app_style.dart';
import 'package:phone_shop/common/custom_textfield.dart';
import 'package:phone_shop/constants/constants.dart';
import 'package:phone_shop/controllers/phone_controller.dart';
import 'package:phone_shop/controllers/subcategory_controller.dart';
import 'package:phone_shop/models/phone_model.dart';
import 'package:phone_shop/models/specs_model.dart';

class AddPhoneScreen extends StatefulWidget {
  const AddPhoneScreen({super.key});

  @override
  State<AddPhoneScreen> createState() => _AddPhoneScreenState();
}

class _AddPhoneScreenState extends State<AddPhoneScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controller = PhoneController();
  final subCategoryController = Get.find<SubCategoryController>();

  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _purchasePriceController = TextEditingController();
  final _sellingPriceController = TextEditingController();
  final _stockController = TextEditingController();
  final _osController = TextEditingController();
  final _chipsetController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  List<File> _selectedImages = [];

  bool _isLoading = false;

  Future<void> _pickImages() async {
    final picked = await _picker.pickMultiImage();
    if (picked.isNotEmpty) {
      setState(() {
        _selectedImages = picked.map((x) => File(x.path)).toList();
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final selectedSubCategoryId = subCategoryController.selectedParentId.value;
    if (selectedSubCategoryId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a subcategory')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final purchase = double.tryParse(_purchasePriceController.text.trim());
    final selling = double.tryParse(_sellingPriceController.text.trim());

    if (purchase == null || selling == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid prices')),
      );
      return;
    }

    final phone = PhoneModel(
      id: '',
      brand: _brandController.text.trim(),
      model: _modelController.text.trim(),
      slug: '${_brandController.text}-${_modelController.text}'.toLowerCase(),
      currency: 'USD',
      pricing: Pricing(
        purchasePrice: purchase,
        sellingPrice: selling,
      ),
      specs: SpecsModel(
        chipset: _chipsetController.text,
        os: _osController.text,
      ),
      category: Category(id: selectedSubCategoryId, name: ''),
      images: [],
      stock: int.tryParse(_stockController.text) ?? 0,
      isActive: true,
    );

    final created = await _controller.addPhone(phone, _selectedImages);

    setState(() => _isLoading = false);

    if (created != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Phone added successfully!')),
      );
      Navigator.pop(context, true);
    } else {
      Get.snackbar("Error", "Failed to add phone");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Phone'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextWidget(
                controller: _brandController,
                label: 'Brand',
                hintText: 'e.g. Samsung',
                validator: (v) => v!.isEmpty ? 'Brand required' : null,
              ),
              SizedBox(height: 12.h),
              CustomTextWidget(
                controller: _modelController,
                label: 'Model',
                hintText: 'e.g. Galaxy S24',
                validator: (v) => v!.isEmpty ? 'Model required' : null,
              ),
              SizedBox(height: 12.h),
              Obx(() {
                final subCats = subCategoryController.subCategories;
                final loading = subCategoryController.isLoading.value;

                if (loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (subCats.isEmpty) {
                  return const Text('No subcategories available');
                }

                return DropdownButtonFormField<String>(
                  value: subCategoryController.selectedParentId.value.isEmpty
                      ? null
                      : subCategoryController.selectedParentId.value,
                  items: subCats
                      .where((c) => c.id.isNotEmpty)
                      .map((c) => DropdownMenuItem<String>(
                            value: c.id,
                            child: Text(c.name),
                          ))
                      .toList(),
                  onChanged: (v) =>
                      subCategoryController.selectedParentId.value = v ?? '',
                  decoration: InputDecoration(
                    labelText: 'Subcategory',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  validator: (v) => v == null || v.isEmpty
                      ? 'Please select a subcategory'
                      : null,
                );
              }),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: CustomTextWidget(
                      controller: _purchasePriceController,
                      label: 'Purchase Price',
                      keyBoardType: TextInputType.number,
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: CustomTextWidget(
                      controller: _sellingPriceController,
                      label: 'Selling Price',
                      keyBoardType: TextInputType.number,
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              CustomTextWidget(
                controller: _stockController,
                label: 'Stock',
                keyBoardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 12.h),
              CustomTextWidget(
                controller: _osController,
                label: 'OS',
                hintText: 'e.g. Android 14',
              ),
              SizedBox(height: 12.h),
              CustomTextWidget(
                controller: _chipsetController,
                label: 'Chipset',
                hintText: 'e.g. Snapdragon 8 Gen 3',
              ),
              SizedBox(height: 16.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Images',
                  style: appStyle(14, kDark, FontWeight.w600),
                ),
              ),
              SizedBox(height: 8.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: [
                  ..._selectedImages.map((img) => Stack(
                        alignment: Alignment.topRight,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: Image.file(
                              img,
                              width: 80.w,
                              height: 80.w,
                              fit: BoxFit.cover,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => setState(() =>
                                _selectedImages.removeWhere((i) => i == img)),
                            child: Container(
                              padding: EdgeInsets.all(4.w),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: const Icon(Icons.close,
                                  color: Colors.white, size: 16),
                            ),
                          )
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
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kLightBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Add Phone'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
