import 'package:get/get.dart';

import '../../../../presentation/chat/controllers/chat.controller.dart';

class ChatControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatController>(
      () => ChatController(),
    );
  }
}
