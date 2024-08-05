import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh_new/pull_to_refresh.dart';

import '../../../data/models/chat.model.dart';
import '../../../data/models/user.model.dart';
import '../../../data/repositories/chat.repository.dart';
import '../../../data/repositories/local.repository.dart';
import '../../../infrastructure/navigation/routes.dart';
import '../../../infrastructure/theme/app.widget.dart';
import '../../home/controllers/home.controller.dart';
import '../chat_find.screen.dart';

class ChatController extends GetxController with StateMixin<List<Chat>> {
  LocalRepository localRepository = Get.find<LocalRepository>();
  HomeController homeController = Get.find<HomeController>();
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

    self = homeController.user;
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

  Future<void> getChats(int page, int pageSize) async {
    try {
      final response = await ChatRepository().getChats(
        page: page,
        pageSize: pageSize,
      );

      if (response.meta!.code != 200) {
        pagingController?.error = response.meta!.messages!.first;
        return;
      }

      if (response.chats == null || response.chats?.isEmpty == true) {
        pagingController?.appendLastPage([]);
        return;
      }

      if (response.chats!.length < pageSize) {
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
