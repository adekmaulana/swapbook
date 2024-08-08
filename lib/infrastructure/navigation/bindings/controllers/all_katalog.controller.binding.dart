import 'package:get/get.dart';

import '../../../../presentation/katalog/controllers/all_katalog.controller.dart';

class AllKatalogControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllKatalogController>(
      () => AllKatalogController(),
    );
  }
}
