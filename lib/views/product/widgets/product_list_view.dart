import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_shop/controllers/phone_controller.dart';
import 'package:phone_shop/models/phone_model.dart';

class ProductListView extends StatelessWidget {
  ProductListView({super.key});

  final PhoneController phoneController = Get.put(PhoneController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // 1️⃣ Show loading spinner
      if (phoneController.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      // 2️⃣ Show empty state
      if (phoneController.products.isEmpty) {
        return const Center(
          child: Text(
            'No products found.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        );
      }

      final List<PhoneModel> products = phoneController.products;

      return ListView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              title: Text(product.model),
              subtitle: Text(product.pricing.sellingPrice.toStringAsFixed(2)),
              trailing: Text(
                "\$${product.stock}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      );
    });
  }
}
