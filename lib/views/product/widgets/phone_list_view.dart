import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:phone_shop/common/show_confirm_dialog.dart';
import 'package:phone_shop/constants/constants.dart';
import 'package:phone_shop/controllers/phone_controller.dart';
import 'package:phone_shop/controllers/switch_controller.dart';
import 'package:phone_shop/models/phone_model.dart';
import 'package:phone_shop/views/product/edit_phone_screen.dart';
import 'package:phone_shop/views/product/generic_list_view.dart';
import 'package:phone_shop/views/product/widgets/product_tile.dart';

class PhoneListView extends StatelessWidget {
  PhoneListView({super.key});

  final phoneController = Get.find<PhoneController>();
  final switchController = Get.find<SwitchController>();

  @override
  Widget build(BuildContext context) {
    return GenericListView<PhoneModel>(
      controller: Get.find<PhoneController>(),
      itemBuilder: (context, product) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 6.h),
          child: Slidable(
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (_) async {
                    final result =
                        await Get.to(() => EditPhoneScreen(phone: product));
                    if (result == true) {
                      phoneController.refetch(); // refresh updated list
                    }
                  },
                  backgroundColor: kBlue.withOpacity(.8),
                  foregroundColor: kWhite,
                  icon: Icons.edit,
                  label: 'Edit',
                  autoClose: true,
                ),
                SlidableAction(
                  onPressed: (_) {
                    showConfirmDialog(
                      context,
                      title: 'Delete Phone',
                      message:
                          'Are you sure to delete ${product.brand} ${product.model}?',
                      confirmText: 'Delete',
                      confirmColor: Colors.red,
                      onConfirm: () => phoneController.deletePhone(product.id),
                    );
                  },
                  backgroundColor: Colors.red,
                  foregroundColor: kWhite,
                  icon: Icons.delete,
                  label: 'Delete',
                  autoClose: true,
                ),
              ],
            ),
            child: ProductTile(
              image: product.images.isNotEmpty ? product.images[0] : '',
              title: "${product.brand} ${product.model}",
              subtitle:
                  "${product.pricing.sellingPrice.toStringAsFixed(2)} ${product.currency}",
              trailing: "Stock: ${product.stock}",
            ),
          ),
        );
      },
    );
  }
}
