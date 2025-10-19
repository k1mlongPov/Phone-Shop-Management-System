import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:phone_shop/common/app_style.dart';
import 'package:phone_shop/common/reusable_text.dart';
import 'package:phone_shop/constants/constants.dart';
import 'package:phone_shop/controllers/accessory_controller.dart';
import 'package:phone_shop/models/accessory_model.dart';
import 'package:phone_shop/views/product/generic_list_view.dart';

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
            child: Container(
              decoration: const BoxDecoration(
                color: kWhite,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.1),
                    blurRadius: 3,
                    spreadRadius: 0,
                    offset: Offset(0, 1),
                  ),
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.06),
                    blurRadius: 2,
                    spreadRadius: 0,
                    offset: Offset(0, 1),
                  )
                ],
              ),
              child: ListTile(
                leading: Image.network(
                  accessory.images.isNotEmpty ? accessory.images[0] : '',
                  width: 50.w,
                  height: 50.h,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.broken_image, size: 40),
                ),
                title: ReusableText(
                  text: accessory.name,
                  style: appStyle(14, kDark, FontWeight.w600),
                ),
                subtitle: ReusableText(
                  text:
                      "${accessory.pricing.sellingPrice.toStringAsFixed(2)} ${accessory.currency}",
                  style: appStyle(12, kBlue, FontWeight.normal),
                ),
                trailing: ReusableText(
                  text: "Stock: ${accessory.stock}",
                  style: appStyle(12, kGray, FontWeight.normal),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
