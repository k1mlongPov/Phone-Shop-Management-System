import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:phone_shop/constants/constants.dart';
import 'package:phone_shop/controllers/accessory_controller.dart';
import 'package:phone_shop/models/accessory_model.dart';
import 'package:phone_shop/views/product/generic_list_view.dart';
import 'package:phone_shop/views/product/widgets/product_tile.dart';

class AccessoryListView extends StatelessWidget {
  AccessoryListView({super.key});

  final accessoryController = Get.find<AccessoryController>();

  @override
  Widget build(BuildContext context) {
    return GenericListView<AccessoryModel>(
      controller: Get.find<AccessoryController>(),
      itemBuilder: (context, accessory) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 6.h),
          child: Slidable(
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (_) {},
                  backgroundColor: kBlue.withOpacity(.8),
                  foregroundColor: kWhite,
                  icon: Icons.edit,
                  label: 'Edit',
                  autoClose: true,
                ),
                SlidableAction(
                  onPressed: (_) {},
                  backgroundColor: Colors.red,
                  foregroundColor: kWhite,
                  icon: Icons.delete,
                  label: 'Delete',
                  autoClose: true,
                ),
              ],
            ),
            child: ProductTile(
                image: accessory.images.isNotEmpty ? accessory.images[0] : '',
                title: accessory.name,
                subtitle:
                    "${accessory.pricing.sellingPrice.toStringAsFixed(2)} ${accessory.currency}",
                trailing: "Stock: ${accessory.stock}"),
          ),
        );
      },
    );
  }
}
