import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_shop/common/app_style.dart';
import 'package:phone_shop/common/custom_button.dart';
import 'package:phone_shop/common/custom_textfield.dart';
import 'package:phone_shop/common/reusable_text.dart';
import 'package:phone_shop/constants/constants.dart';
import 'package:phone_shop/controllers/supplier_controller.dart';

class AddSupplierScreen extends StatefulWidget {
  const AddSupplierScreen({super.key});

  @override
  State<AddSupplierScreen> createState() => _AddSupplierScreenState();
}

class _AddSupplierScreenState extends State<AddSupplierScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final contactNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final supplierController = Get.find<SupplierController>();

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    await supplierController.addSupplier(
      nameController.text.trim(),
      contactNameController.text.trim(),
      emailController.text.trim(),
      phoneController.text.trim(),
      addressController.text.trim(),
    );

    Get.back(); // Close form
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ReusableText(
          text: 'Add Supplier',
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextWidget(
                  controller: nameController,
                  label: "Supplier Name",
                  hintText: "e.g. TechWorld Distributors",
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Supplier name required' : null,
                ),
                SizedBox(height: 16.h),
                CustomTextWidget(
                  controller: contactNameController,
                  label: "Contact Name",
                  hintText: "e.g. San Vibol",
                ),
                SizedBox(height: 16.h),
                CustomTextWidget(
                  controller: phoneController,
                  label: "Phone number",
                  hintText: "e.g. +85512345678",
                ),
                SizedBox(height: 16.h),
                CustomTextWidget(
                  controller: emailController,
                  label: "Email",
                  hintText: "e.g. abc@gmail.com",
                ),
                SizedBox(height: 16.h),
                CustomTextWidget(
                  controller: addressController,
                  label: "Address (Optional)",
                  hintText: "e.g. No.123, St.456, Phnom Penh",
                ),
                SizedBox(height: 24.h),
                CustomButton(
                  text: "Add Supplier",
                  btnHeight: 46,
                  btnColor: kBlue,
                  onTap: _handleSubmit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
