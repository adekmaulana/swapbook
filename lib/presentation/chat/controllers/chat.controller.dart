import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_new/pull_to_refresh.dart';
import 'package:swapbook/presentation/screens.dart';

import '../../../data/models/chat.model.dart';
import '../../../data/models/user.model.dart';
import '../../../data/repositories/chat.repository.dart';
import '../../../data/repositories/local.repository.dart';
import '../../../infrastructure/constant.dart';
import '../../../infrastructure/navigation/routes.dart';
import '../../../infrastructure/theme/app.widget.dart';

class ChatController extends GetxController with StateMixin<List<Chat>> {
  LocalRepository localRepository = Get.find<LocalRepository>();
  RefreshController refreshController = RefreshController(
    initialRefresh: false,
  );
  TextEditingController searchController = TextEditingController();

  RxString chatName = ''.obs;
  RxString chatInitial = ''.obs;
  Rx<User> self = User().obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    await getChats();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getChats() async {
    change(null, status: RxStatus.loading());
    try {
      final response = await ChatRepository().getChats();
      if (response.meta!.code != 200) {
        change(
          null,
          status: RxStatus.error(response.meta!.messages!.first),
        );
        return;
      }

      if (response.chats == null || response.chats?.isEmpty == true) {
        change(null, status: RxStatus.empty());
        return;
      }

      self.value = User.fromJson(
        jsonDecode(
          await localRepository.get(
            LocalRepositoryKey.USER,
            '{}',
          ),
        ),
      );
      self.refresh();

      change(response.chats, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    } finally {
      refreshController.refreshCompleted();
    }
  }

  void searchUser() {
    AppWidget.showBottomSheet(
      routeName: Routes.CHAT_FIND,
      child: const ChatFindScreen(),
    );
  }
}
