import 'package:flutter/material.dart';
import 'package:phone_shop/common/custom_button.dart';
import 'package:phone_shop/common/show_confirm_dialog.dart';
import 'package:phone_shop/constants/constants.dart';

class ConfirmSubmitButton extends StatelessWidget {
  final bool isEdit;
  final VoidCallback onConfirm;

  const ConfirmSubmitButton({
    super.key,
    required this.isEdit,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      btnHeight: 46,
      onTap: () {
        showConfirmDialog(
          context,
          title: isEdit ? 'Update Phone' : 'Add Phone',
          message: isEdit
              ? 'Are you sure you want to update this phone?'
              : 'Are you sure you want to add this phone?',
          confirmText: isEdit ? 'Update' : 'Add',
          confirmColor:
              isEdit ? kBlue.withOpacity(.8) : Colors.green.withOpacity(.8),
          onConfirm: onConfirm,
        );
      },
      text: isEdit ? 'Update Phone' : 'Add Phone',
    );
  }
}
