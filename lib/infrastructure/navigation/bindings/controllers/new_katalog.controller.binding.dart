import 'package:get/get.dart';

import '../../../../presentation/katalog/controllers/new_katalog.controller.dart';

class NewKatalogControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewKatalogController>(
      () => NewKatalogController(),
    );
  }
}
