import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phone_shop/common/app_style.dart';
import 'package:phone_shop/common/custom_textfield.dart';
import 'package:phone_shop/common/reusable_text.dart';
import 'package:phone_shop/constants/constants.dart';
import 'package:phone_shop/controllers/base_product_controller.dart';

class SearchAndFilterWidget<T> extends StatelessWidget {
  final BaseProductController<T> controller;
  final Map<String, String> sortOptions;

  const SearchAndFilterWidget({
    super.key,
    required this.controller,
    required this.sortOptions,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 🔍 Search Box
          SizedBox(
              width: 210.w,
              height: 45.h,
              child: CustomTextWidget(
                onChanged: (value) => controller.search(value.trim()),
                hintText: 'Search Products...',
                prefixIcon: Icon(
                  Icons.search,
                  size: 20.r,
                  color: kGray,
                ),
              )),

          // ↕️ Sort Dropdown
          Obx(() {
            final selectedKey = controller.sortOption.value;
            final selectedLabel = selectedKey.isEmpty
                ? 'Sort by'
                : sortOptions[selectedKey] ?? 'Sort by';

            return GestureDetector(
              onTap: () => _showSortSheet(context),
              child: Container(
                width: 130.w,
                height: 45.h,
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: kGray),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 80.w,
                      child: ReusableText(
                        text: selectedLabel,
                        overflow: TextOverflow.ellipsis,
                        style: appStyle(12, kGray, FontWeight.normal),
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_down, size: 18.r, color: kDark),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  void _showSortSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SizedBox(
          height: .6.sh,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
            child: Column(
              children: [
                Container(
                  width: 40.w,
                  height: 4.h,
                  margin: EdgeInsets.only(bottom: 10.h),
                  decoration: BoxDecoration(
                    color: kGray.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                Container(
                  height: 50.h,
                  alignment: Alignment.center,
                  child: Text(
                    'Sort Options',
                    style: appStyle(14, kDark, FontWeight.bold),
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.separated(
                    itemCount: sortOptions.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final entry = sortOptions.entries.elementAt(index);
                      final key = entry.key;
                      final label = entry.value;

                      return ListTile(
                        title: Text(
                          label,
                          style: appStyle(
                            13,
                            kDark,
                            key == controller.sortOption.value
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        trailing: key == controller.sortOption.value
                            ? const Icon(Icons.check, color: kBlue)
                            : null,
                        onTap: () {
                          controller.sort(key);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
