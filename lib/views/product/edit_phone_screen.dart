import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_shop/common/app_style.dart';
import 'package:phone_shop/common/reusable_text.dart';
import 'package:phone_shop/constants/constants.dart';
import 'package:phone_shop/controllers/phone_controller.dart';
import 'package:phone_shop/models/phone_model.dart';
import 'package:phone_shop/models/specs_model.dart';
import 'package:phone_shop/models/supplier_model.dart';
import 'package:phone_shop/views/product/widgets/phone_form_widget.dart';

class EditPhoneScreen extends StatelessWidget {
  final PhoneModel phone;
  EditPhoneScreen({super.key, required this.phone});
  final controller = Get.find<PhoneController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: const Icon(
            Icons.arrow_back_outlined,
            color: kWhite,
          ),
        ),
        title: ReusableText(
          text: 'Edit Phone',
          style: appStyle(16, kWhite, FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: kBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: PhoneFormWidget(
          initialPhone: phone,
          isEdit: true,
          onSubmit: (data) async {
            await controller.updatePhone(
              phone.id,
              PhoneModel(
                id: phone.id,
                brand: data.brand,
                model: data.model,
                slug: data.slug,
                currency: 'USD',
                pricing: Pricing(
                  purchasePrice: data.purchasePrice,
                  sellingPrice: data.sellingPrice,
                ),
                specs: SpecsModel(chipset: data.chipset, os: data.os),
                category: Category(id: data.categoryId, name: ''),
                supplier:
                    SupplierModel(id: data.supplierId, name: '', active: true),
                images: data.existingImages,
                stock: data.stock,
                isActive: true,
              ),
              data.newImages,
            );
            Get.back(result: true);
          },
        ),
      ),
    );
  }
}
