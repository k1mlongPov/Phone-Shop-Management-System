import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_shop/common/app_style.dart';
import 'package:phone_shop/constants/constants.dart';

Future<void> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmText,
  Color? confirmColor,
  required VoidCallback onConfirm,
  VoidCallback? onCancel,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        backgroundColor: kWhite,
        title: Text(
          title,
          style: appStyle(16, kDark, FontWeight.w700),
        ),
        content: Text(
          message,
          style: appStyle(13, kDark.withOpacity(0.8), FontWeight.w400),
        ),
        actionsPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (onCancel != null) onCancel();
            },
            style: TextButton.styleFrom(
              foregroundColor: kDark,
              textStyle: appStyle(13, kDark, FontWeight.w500),
            ),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmColor ?? kBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
            ),
            child: Text(
              confirmText,
              style: appStyle(13, kWhite, FontWeight.w600),
            ),
          ),
        ],
      );
    },
  );
}
