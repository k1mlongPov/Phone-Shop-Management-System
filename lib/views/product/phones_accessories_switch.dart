import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phone_shop/common/app_style.dart';
import 'package:phone_shop/common/reusable_text.dart';
import 'package:phone_shop/constants/constants.dart';
import 'package:phone_shop/controllers/switch_controller.dart';

class PhonesAccessoriesSwitch extends StatelessWidget {
  final SwitchController controller = Get.put(SwitchController());

  final double height;
  final double width;

  PhonesAccessoriesSwitch({
    super.key,
    this.height = 44,
    this.width = 375,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(height / 5);

    return Obx(
      () {
        final isPhone = controller.isSwitch.value;
        return SizedBox(
          width: width,
          height: height,
          child: Material(
            color: Colors.transparent,
            child: Stack(
              children: [
                // Outer border
                Container(
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    border: Border.all(color: Colors.grey),
                  ),
                ),
                // Sliding selector
                AnimatedAlign(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOutCubic,
                  alignment:
                      isPhone ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(
                    width: width / 2,
                    height: height - 4,
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.blue.shade50
                          : Colors.blueGrey.shade700.withOpacity(0.35),
                      borderRadius: borderRadius,
                    ),
                  ),
                ),
                // Labels & hit areas
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        borderRadius: borderRadius,
                        onTap: controller.toggleToLeft,
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.email,
                                  size: 16.r,
                                  color: isPhone
                                      ? kBlue.withOpacity(0.5)
                                      : Theme.of(context).iconTheme.color),
                              SizedBox(width: 8.w),
                              ReusableText(
                                text: 'Phones',
                                style: appStyle(
                                  14,
                                  isPhone ? kBlue.withOpacity(0.5) : kDark,
                                  FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        borderRadius: borderRadius,
                        onTap: controller.toggleToRight,
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.phone_android,
                                  size: 16.r,
                                  color: !isPhone
                                      ? kBlue.withOpacity(0.5)
                                      : Theme.of(context).iconTheme.color),
                              SizedBox(width: 8.w),
                              ReusableText(
                                text: 'Accessories',
                                style: appStyle(
                                  14,
                                  !isPhone ? kBlue.withOpacity(0.5) : kDark,
                                  FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
