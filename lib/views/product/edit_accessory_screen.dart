import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_shop/common/app_style.dart';
import 'package:phone_shop/common/reusable_text.dart';
import 'package:phone_shop/constants/constants.dart';
import 'package:phone_shop/controllers/accessory_controller.dart';
import 'package:phone_shop/models/accessory_model.dart';
import 'package:phone_shop/models/category_model.dart';
import 'package:phone_shop/models/pricing_model.dart';
import 'package:phone_shop/models/supplier_model.dart';
import 'package:phone_shop/views/product/widgets/accessory_form_widget.dart';

class EditAccessoryScreen extends StatelessWidget {
  EditAccessoryScreen({super.key, required this.accessory});
  final AccessoryModel accessory;
  final controller = Get.find<AccessoryController>();

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
        child: AccessoryFormWidget(
          initialAccessory: accessory,
          isEdit: true,
          onSubmit: (data) async {
            await controller.updateAccessory(
              accessory.id,
              AccessoryModel(
                id: accessory.id,
                name: data.name,
                type: data.type,
                brand: data.brand,
                pricing: Pricing(
                  purchasePrice: data.purchasePrice,
                  sellingPrice: data.sellingPrice,
                ),
                currency: 'USD',
                sku: data.sku,
                images: data.existingImages,
                compatibility: data.compatibility,
                stock: data.stock,
                lowStockThreshold: data.lowStockThreshold,
                category: CategoryModel(
                    id: data.categoryId, name: '', isActive: true),
                supplier:
                    SupplierModel(id: data.supplierId, name: '', active: true),
                isActive: true,
                profitMargin: (data.sellingPrice - data.purchasePrice) /
                    data.sellingPrice *
                    100,
              ),
              data.newImages,
            );
          },
        ),
      ),
    );
  }
}
