import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_shop/common/app_style.dart';
import 'package:phone_shop/constants/constants.dart';

class SelectionBottomSheet<T> {
  static void show<T>({
    required BuildContext context,
    required String title,
    required List<T> items,
    required String? selectedId,
    required String Function(T) getId,
    required String Function(T) getLabel,
    required void Function(T selected) onSelect,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: 0.5.sh,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
            child: Column(
              children: [
                // handle bar
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
                  height: 40.h,
                  alignment: Alignment.center,
                  child: Text(
                    title,
                    style: appStyle(14, kDark, FontWeight.bold),
                  ),
                ),
                const Divider(height: 1),

                // Your reusable list logic
                Expanded(
                  child: ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final bool isSelected = getId(item) == selectedId;

                      return ListTile(
                        title: Text(
                          getLabel(item),
                          style: appStyle(
                            13,
                            kDark,
                            isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        trailing: isSelected
                            ? const Icon(Icons.check, color: kBlue)
                            : null,
                        onTap: () {
                          onSelect(item);
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
