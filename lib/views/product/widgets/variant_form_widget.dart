import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_shop/common/custom_textfield.dart';
import 'package:phone_shop/constants/constants.dart';
import 'package:phone_shop/models/pricing_model.dart';
import 'package:phone_shop/models/variant_form_data.dart';

class VariantFormWidget extends StatefulWidget {
  final int index;
  final VariantFormData variant;
  final void Function(int) onRemove;
  final void Function(int, VariantFormData) onUpdate;

  const VariantFormWidget({
    super.key,
    required this.index,
    required this.variant,
    required this.onRemove,
    required this.onUpdate,
  });

  @override
  State<VariantFormWidget> createState() => _VariantFormWidgetState();
}

class _VariantFormWidgetState extends State<VariantFormWidget> {
  late TextEditingController storageCtrl;
  late TextEditingController colorCtrl;
  late TextEditingController purchaseCtrl;
  late TextEditingController sellingCtrl;
  late TextEditingController stockCtrl;

  bool isExpanded = true;

  @override
  void initState() {
    super.initState();

    storageCtrl = TextEditingController(text: widget.variant.storage);
    colorCtrl = TextEditingController(text: widget.variant.color ?? '');
    purchaseCtrl = TextEditingController(
        text: widget.variant.pricing.purchasePrice.toString());
    sellingCtrl = TextEditingController(
        text: widget.variant.pricing.sellingPrice.toString());
    stockCtrl = TextEditingController(text: widget.variant.stock.toString());

    storageCtrl.addListener(_updateVariant);
    colorCtrl.addListener(_updateVariant);
    purchaseCtrl.addListener(_updateVariant);
    sellingCtrl.addListener(_updateVariant);
    stockCtrl.addListener(_updateVariant);
  }

  void _updateVariant() {
    widget.onUpdate(
      widget.index,
      VariantFormData(
        storage: storageCtrl.text,
        color: colorCtrl.text,
        pricing: Pricing(
          purchasePrice: double.tryParse(purchaseCtrl.text) ?? 0,
          sellingPrice: double.tryParse(sellingCtrl.text) ?? 0,
        ),
        stock: int.tryParse(stockCtrl.text) ?? 0,
      ),
    );
  }

  @override
  void dispose() {
    storageCtrl.dispose();
    colorCtrl.dispose();
    purchaseCtrl.dispose();
    sellingCtrl.dispose();
    stockCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Generate nice header text for each variant
    final variantLabel = StringBuffer('Variant ${widget.index + 1}');
    if (storageCtrl.text.isNotEmpty) {
      variantLabel.write(' - ${storageCtrl.text}');
    }
    if (colorCtrl.text.isNotEmpty) variantLabel.write(' (${colorCtrl.text})');

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: kGray.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // 🔹 Header Row with Expand/Collapse
          InkWell(
            onTap: () => setState(() => isExpanded = !isExpanded),
            borderRadius: BorderRadius.circular(12.r),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  variantLabel.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    fontSize: 13.sp,
                  ),
                ),
                Row(
                  children: [
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: const Icon(Icons.keyboard_arrow_down),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => widget.onRemove(widget.index),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 🔹 Expandable Content
          AnimatedCrossFade(
            crossFadeState: isExpanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 250),
            firstChild: Column(
              children: [
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextWidget(
                        controller: storageCtrl,
                        label: 'Storage',
                        hintText: 'e.g. 128GB',
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: CustomTextWidget(
                        controller: colorCtrl,
                        label: 'Color',
                        hintText: 'e.g. Black',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextWidget(
                        controller: purchaseCtrl,
                        label: 'Purchase Price',
                        keyBoardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: CustomTextWidget(
                        controller: sellingCtrl,
                        label: 'Selling Price',
                        keyBoardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                CustomTextWidget(
                  controller: stockCtrl,
                  label: 'Stock',
                  keyBoardType: TextInputType.number,
                ),
              ],
            ),
            secondChild: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
