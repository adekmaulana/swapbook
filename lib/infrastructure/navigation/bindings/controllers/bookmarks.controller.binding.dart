import 'package:get/get.dart';

import '../../../../presentation/bookmarks/controllers/bookmarks.controller.dart';

class BookmarksControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookmarksController>(
      () => BookmarksController(),
    );
  }
}
