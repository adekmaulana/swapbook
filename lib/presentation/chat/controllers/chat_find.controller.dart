import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../data/models/user.model.dart';
import '../../../domain/case/chat/create_chat.case.dart';
import '../../../domain/case/user/search_user.case.dart';
import '../../../infrastructure/navigation/routes.dart';
import '../../../infrastructure/theme/app.widget.dart';
import '../../home/controllers/home.controller.dart';
import 'chat.controller.dart';

class ChatFindController extends GetxController with StateMixin<List<User>> {
  TextEditingController searchController = TextEditingController();
  ChatController chatController = Get.find<ChatController>();
  HomeController homeController = Get.find<HomeController>();

  RxString search = ''.obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    change(null, status: RxStatus.empty());
    debounce(
      search,
      (_) async {
        if (search.value.isEmpty) {
          change(null, status: RxStatus.empty());
          return;
        }

        await searchUser();
      },
      time: 550.milliseconds,
    );
  }

  @override
  void onReady() {
    super.onReady();
  }

  void onSearch(String value) {
    if (value.isEmpty) {
      change(null, status: RxStatus.empty());
    }

    search.value = value;
  }

  @override
  void onClose() {
    searchController.dispose();

    super.onClose();
  }

  Future<void> searchUser() async {
    change(null, status: RxStatus.loading());
    try {
      final response = await SearchUserCase().call(search.value);
      if (response.meta!.code != 200) {
        change(
          null,
          status: RxStatus.error(response.meta!.messages!.first),
        );
        return;
      }

      if (response.users == null || response.users?.isEmpty == true) {
        change(null, status: RxStatus.empty());
        return;
      }

      change(response.users, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  Future<void> createChat(int userId) async {
    try {
      final response = await CreateChatCase()(userId);
      if (response.meta!.code != 200) {
        AppWidget.openSnackbar(
          "Oops! Something went wrong",
          response.meta!.messages!.first,
        );
        return;
      }

      if (response.chat == null) {
        AppWidget.openSnackbar(
          "Oops! Something went wrong",
          "We couldn't create a chat room for you now. Please try again later.",
        );
        return;
      }

      Get.back(); // close the bottom sheet
      Get.toNamed(
        Routes.CHAT_ROOM,
        arguments: {
          'chat': response.chat,
          'user': response.chat!.participants!
              .firstWhere(
                (element) => element.user!.id != chatController.self.value.id,
              )
              .user,
        },
      );
    } catch (e) {
      AppWidget.openSnackbar(
        "Oops! Something went wrong",
        "Please try again later.",
      );
    }
  }
}
