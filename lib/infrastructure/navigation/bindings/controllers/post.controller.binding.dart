import 'package:get/get.dart';

import '../../../../presentation/post/controllers/post.controller.dart';

class PostControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PostController>(
      () => PostController(),
    );
  }
}
