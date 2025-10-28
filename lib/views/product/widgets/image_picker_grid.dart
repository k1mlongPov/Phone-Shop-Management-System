import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phone_shop/common/app_style.dart';
import 'package:phone_shop/constants/constants.dart';

class ImagePickerGrid extends StatefulWidget {
  final List<String> existingImages;
  final List<File> newImages;
  final Function(List<File>) onPick;
  final Function(String) onRemoveExisting;
  final Function(File) onRemoveNew;

  const ImagePickerGrid({
    super.key,
    required this.existingImages,
    required this.newImages,
    required this.onPick,
    required this.onRemoveExisting,
    required this.onRemoveNew,
  });

  @override
  State<ImagePickerGrid> createState() => _ImagePickerGridState();
}

class _ImagePickerGridState extends State<ImagePickerGrid> {
  final picker = ImagePicker();

  Future<void> _pickImages() async {
    final picked = await picker.pickMultiImage(imageQuality: 75);
    if (picked.isNotEmpty) {
      final files = picked.map((x) => File(x.path)).toList();
      widget.onPick(files);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Images', style: appStyle(14, kDark, FontWeight.w600)),
        SizedBox(height: 8.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            // Existing images
            ...widget.existingImages.map(
              (url) => Stack(
                alignment: Alignment.topRight,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Image.network(
                      url,
                      width: 80.w,
                      height: 80.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => widget.onRemoveExisting(url),
                    child: Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: const Icon(Icons.close,
                          color: Colors.white, size: 16),
                    ),
                  ),
                ],
              ),
            ),

            // New images
            ...widget.newImages.map(
              (file) => Stack(
                alignment: Alignment.topRight,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Image.file(
                      file,
                      width: 80.w,
                      height: 80.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => widget.onRemoveNew(file),
                    child: Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: const Icon(Icons.close,
                          color: Colors.white, size: 16),
                    ),
                  ),
                ],
              ),
            ),

            // Add button
            GestureDetector(
              onTap: _pickImages,
              child: Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: kGray),
                ),
                child: const Icon(Icons.add_a_photo_outlined),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
