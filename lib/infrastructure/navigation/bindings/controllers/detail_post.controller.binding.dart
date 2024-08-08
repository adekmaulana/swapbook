import 'package:get/get.dart';

import '../../../../presentation/detail_post/controllers/detail_post.controller.dart';

class DetailPostControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailPostController>(
      () => DetailPostController(),
    );
  }
}
