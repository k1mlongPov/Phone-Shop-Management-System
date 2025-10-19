import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:phone_shop/common/app_style.dart';
import 'package:phone_shop/common/reusable_text.dart';
import 'package:phone_shop/constants/constants.dart';
import 'package:phone_shop/controllers/phone_controller.dart';
import 'package:phone_shop/models/phone_model.dart';
import 'package:phone_shop/views/product/generic_list_view.dart';

class PhoneListView extends StatelessWidget {
  PhoneListView({super.key});

  final phoneController = Get.find<PhoneController>();

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
              width: width,
              height: 70.h,
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
                  product.images.isNotEmpty ? product.images[0] : '',
                  width: 50.w,
                  height: 50.h,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.broken_image, size: 40),
                ),
                title: ReusableText(
                  text: "${product.brand} ${product.model}",
                  style: appStyle(14, kDark, FontWeight.w600),
                ),
                subtitle: ReusableText(
                  text:
                      "${product.pricing.sellingPrice.toStringAsFixed(2)} ${product.currency}",
                  style: appStyle(12, kBlue, FontWeight.normal),
                ),
                trailing: ReusableText(
                  text: "Stock: ${product.stock}",
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
