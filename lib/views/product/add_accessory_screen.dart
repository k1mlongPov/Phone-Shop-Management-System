import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_shop/common/app_style.dart';
import 'package:phone_shop/common/reusable_text.dart';
import 'package:phone_shop/constants/constants.dart';
import 'package:phone_shop/controllers/accessory_controller.dart';
import 'package:phone_shop/controllers/supplier_controller.dart';
import 'package:phone_shop/views/product/widgets/accessory_form_widget.dart';

class AddAccessoryScreen extends StatelessWidget {
  AddAccessoryScreen({super.key});

  final controller = Get.find<AccessoryController>();
  final supplierController = Get.find<SupplierController>();

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
          text: 'Add new Phone',
          style: appStyle(16, kWhite, FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: kBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: AccessoryFormWidget(
          onSubmit: (data) async {
            final supplierId = supplierController.selectedSupplierId.value;
            await controller.addAccessory(
              name: data.name,
              type: data.type,
              brand: data.brand,
              sku: data.sku,
              purchasePrice: data.purchasePrice,
              sellingPrice: data.sellingPrice,
              categoryId: data.categoryId,
              supplierId: supplierId.isEmpty ? null : supplierId,
              stock: data.stock,
              lowStockThreshold: data.lowStockThreshold,
              attributes: data.attributes,
              compatibility: data.compatibility,
              images: data.newImages,
            );
            Get.back(result: true);
          },
        ),
      ),
    );
  }
}
