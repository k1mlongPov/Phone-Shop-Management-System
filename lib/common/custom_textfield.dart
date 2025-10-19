import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_shop/common/app_style.dart';
import 'package:phone_shop/constants/constants.dart';

class CustomTextWidget extends StatelessWidget {
  const CustomTextWidget({
    super.key,
    this.keyBoardType,
    this.controller,
    this.onEditingComplete,
    this.obscureText,
    this.suffixIcon,
    this.validator,
    this.prefixIcon,
    this.hintText,
    this.onChanged,
    this.label,
  });

  final TextInputType? keyBoardType;
  final TextEditingController? controller;
  final String? hintText;
  final String? label;
  final VoidCallback? onEditingComplete;
  final bool? obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorHeight: 16.h,
      cursorColor: kLightBlue,
      controller: controller,
      textAlignVertical: TextAlignVertical.center,
      keyboardType: keyBoardType,
      onEditingComplete: onEditingComplete,
      onChanged: onChanged,
      obscureText: obscureText ?? false,
      style: appStyle(14, kDark, FontWeight.normal),
      validator: validator,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: .6, color: kGray),
            borderRadius: BorderRadius.circular(12.r)),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: kLightBlue, width: 1),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.red),
        ),
        hintText: hintText,
        labelText: label,
        labelStyle: appStyle(12, kGray, FontWeight.w600),
        hintStyle: appStyle(12, kGray, FontWeight.normal),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
      ),
    );
  }
}

class CustomTextFieldWithError extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? label;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Function()? onEditingComplete;

  const CustomTextFieldWithError({
    super.key,
    required this.controller,
    this.hintText,
    this.keyboardType,
    this.validator,
    this.label,
    this.onEditingComplete,
  });

  @override
  Widget build(BuildContext context) {
    String? errorText;

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextWidget(
              controller: controller,
              keyBoardType: keyboardType,
              hintText: hintText,
              label: label,
              validator: (value) {
                final result = validator?.call(value);
                setState(() => errorText = result);
                return null;
              },
              onEditingComplete: onEditingComplete,
            ),
            if (errorText != null)
              Padding(
                padding: EdgeInsets.only(top: 4.h, left: 4.w),
                child: Text(
                  errorText!,
                  style: appStyle(10, Colors.red, FontWeight.w500),
                ),
              ),
          ],
        );
      },
    );
  }
}
