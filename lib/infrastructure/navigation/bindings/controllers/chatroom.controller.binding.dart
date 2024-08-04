import 'package:get/get.dart';

import '../../../../presentation/chatroom/controllers/chatroom.controller.dart';

class ChatroomControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatroomController>(
      () => ChatroomController(),
      fenix: true,
    );
  }
}
