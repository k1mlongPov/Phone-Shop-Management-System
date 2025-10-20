import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phone_shop/common/app_style.dart';
import 'package:phone_shop/common/reusable_text.dart';
import 'package:phone_shop/common/shimmers/products_shimmer.dart';
import 'package:phone_shop/constants/constants.dart';
import 'package:phone_shop/controllers/base_product_controller.dart';

class GenericListView<T> extends StatelessWidget {
  final BaseProductController<T> controller;
  final Widget Function(BuildContext context, T item) itemBuilder;

  const GenericListView({
    super.key,
    required this.controller,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) return const ProductsShimmer();

      if (controller.items.isEmpty) {
        return Center(
          child: ReusableText(
            text: "No Product found",
            style: appStyle(14, kDark, FontWeight.w600),
          ),
        );
      }

      final items = controller.items;

      return RefreshIndicator(
        color: kBlue,
        backgroundColor: kWhite,
        onRefresh: controller.refetch,
        child: Scrollbar(
          trackVisibility: true,
          thumbVisibility: true,
          radius: Radius.circular(10.r),
          child: ListView.builder(
            padding: EdgeInsets.only(right: 10.w),
            controller: controller.scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: items.length + (controller.hasMore.value ? 3 : 0),
            itemBuilder: (context, index) {
              if (index >= items.length) {
                return Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 6.h, horizontal: 16.w),
                  child: const ProductsShimmerTile(),
                );
              }

              return itemBuilder(context, items[index]);
            },
          ),
        ),
      );
    });
  }
}
