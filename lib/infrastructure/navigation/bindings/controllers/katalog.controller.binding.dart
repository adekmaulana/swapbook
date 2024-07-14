import 'package:get/get.dart';

import '../../../../presentation/katalog/controllers/katalog.controller.dart';

class KatalogControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KatalogController>(
      () => KatalogController(),
    );
  }
}
