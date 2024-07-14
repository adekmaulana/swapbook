import 'package:get/get.dart';

import '../../home/controllers/home.controller.dart';

class KatalogController extends GetxController {
  HomeController homeController = Get.find<HomeController>();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void openDrawer() {
    homeController.scaffoldKey.currentState?.openDrawer();
  }
}
