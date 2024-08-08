import 'package:get/get.dart';

import '../../../../presentation/chat/controllers/chat_find.controller.dart';

class ChatFindControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatFindController>(
      () => ChatFindController(),
    );
  }
}
