import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_shop/controllers/subcategory_controller.dart';

class TabNavController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  var currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();

    tabController = TabController(length: 4, vsync: this);

    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        currentIndex.value = tabController.index;

        final subcategoryController = Get.find<SubCategoryController>();
        if (tabController.index == 0) {
          subcategoryController.fetchForType('phone', force: true);
        } else if (tabController.index == 1) {
          subcategoryController.fetchForType('accessory', force: true);
        }
      }
    });
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
