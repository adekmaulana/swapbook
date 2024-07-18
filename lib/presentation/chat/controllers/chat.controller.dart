import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh_new/pull_to_refresh.dart';

import '../../../data/models/chat.model.dart';
import '../../../data/models/user.model.dart';
import '../../../data/repositories/chat.repository.dart';
import '../../../data/repositories/local.repository.dart';
import '../../../infrastructure/constant.dart';
import '../../../infrastructure/navigation/routes.dart';
import '../../../infrastructure/theme/app.widget.dart';
import '../chat_find.screen.dart';

class ChatController extends GetxController with StateMixin<List<Chat>> {
  LocalRepository localRepository = Get.find<LocalRepository>();
  RefreshController refreshController = RefreshController(
    initialRefresh: false,
  );
  PagingController<int, Chat>? pagingController;
  TextEditingController searchController = TextEditingController();

  RxString chatName = ''.obs;
  RxString chatInitial = ''.obs;
  Rx<User> self = User().obs;

  @override
  Future<void> onInit() async {
    pagingController = PagingController<int, Chat>(
      firstPageKey: 1,
    );
    pagingController?.addPageRequestListener((pageKey) {
      getChats(pageKey, 10);
    });

    self.value = User.fromJson(
      jsonDecode(
        await localRepository.get(
          LocalRepositoryKey.USER,
          '{}',
        ),
      ),
    );
    self.refresh();

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    refreshController.dispose();
    searchController.dispose();

    super.onClose();
  }

  Future<void> getChats(int page, int limit) async {
    try {
      final response = await ChatRepository().getChats(
        page: page,
        limit: limit,
      );

      if (response.meta!.code != 200) {
        pagingController?.error = response.meta!.messages!.first;
        return;
      }

      if (response.chats == null || response.chats?.isEmpty == true) {
        pagingController?.appendLastPage([]);
        return;
      }

      if (response.chats!.length < limit) {
        pagingController?.appendLastPage(response.chats!);
        return;
      }

      pagingController?.appendPage(
        response.chats!,
        page + 1,
      );
    } catch (e) {
      AppWidget.openSnackbar(
        'Oops! Something went wrong',
        'There was an error while fetching chats data.',
      );
      pagingController?.error = e;
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
