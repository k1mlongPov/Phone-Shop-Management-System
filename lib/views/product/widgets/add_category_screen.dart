import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_shop/common/app_style.dart';
import 'package:phone_shop/common/custom_button.dart';
import 'package:phone_shop/common/custom_textfield.dart';
import 'package:phone_shop/common/reusable_text.dart';
import 'package:phone_shop/constants/constants.dart';
import 'package:phone_shop/controllers/category_controller.dart';
import 'package:phone_shop/controllers/subcategory_controller.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final subCategoryController = Get.find<SubCategoryController>();
  final categoryController = Get.find<CategoryController>();

  String? selectedParentId;

  @override
  void initState() {
    super.initState();
    // Load parent categories (like Phones, Accessories)
    categoryController.fetchCategories();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedParentId == null || selectedParentId!.isEmpty) {
      Get.snackbar('Error', 'Please select a parent category.');
      return;
    }
    final success = await subCategoryController.addSubcategory(
      selectedParentId!,
      nameController.text.trim(),
    );
    if (success) {
      Future.delayed(
        const Duration(milliseconds: 300),
        () => Get.back(closeOverlays: true),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ReusableText(
          text: 'Add Subcategory',
          style: appStyle(18, kWhite, FontWeight.w600),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.close,
            size: 24.w,
            color: kWhite,
          ),
          onPressed: () => Get.back(),
        ),
        backgroundColor: kBlue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Obx(() {
                if (categoryController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                return DropdownButtonFormField<String>(
                  dropdownColor: kWhite,
                  padding: EdgeInsets.symmetric(
                    vertical: 4.h,
                  ),
                  style: appStyle(12, kDark, FontWeight.w400),
                  decoration: InputDecoration(
                    labelStyle: appStyle(12, kGray, FontWeight.w400),
                    labelText: "Parent Category",
                    errorStyle: appStyle(12, Colors.red, FontWeight.w400),
                    border: const OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(color: kGray, width: .6.w),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(color: kGray, width: .6.w),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(color: Colors.red, width: .6.w),
                    ),
                  ),
                  items: categoryController.categories
                      .map((cat) => DropdownMenuItem(
                            value: cat.id,
                            child: Text(cat.name),
                          ))
                      .toList(),
                  onChanged: (val) => setState(() => selectedParentId = val),
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Select a parent' : null,
                );
              }),
              SizedBox(height: 16.h),
              CustomTextWidget(
                controller: nameController,
                label: "Subcategory Name",
                hintText: "e.g. iPhone, Samsung, Earbuds",
                validator: (v) =>
                    v == null || v.isEmpty ? 'Name is required' : null,
              ),
              SizedBox(height: 16.h),
              CustomTextWidget(
                controller: descriptionController,
                label: "Description (Optional)",
                hintText: "Short description",
              ),
              SizedBox(height: 24.h),
              CustomButton(
                text: "Add Subcategory",
                btnHeight: 46,
                btnColor: kBlue,
                onTap: _handleSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
