import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:keyboard_detection/keyboard_detection.dart';

import '../../../data/models/chat.model.dart';
import '../../../data/models/message.model.dart';
import '../../../data/models/participant.model.dart';
import '../../../data/models/user.model.dart';
import '../../../data/repositories/local.repository.dart';
import '../../../data/repositories/message.repository.dart';
import '../../../infrastructure/constant.dart';
import '../../../infrastructure/theme/app.widget.dart';
import '../../chat/controllers/chat.controller.dart';

class ChatroomController extends GetxController with StateMixin {
  TextEditingController messageController = TextEditingController();
  LocalRepository localRepository = Get.find<LocalRepository>();
  MessageRepository messageRepository = MessageRepository();
  PagingController<int, Message>? pagingController;
  ChatController chatController = Get.find<ChatController>();

  bool shouldRefresh = false;

  RxString chatInitial = ''.obs;
  RxString chatName = ''.obs;
  RxString message = ''.obs;
  RxBool sending = false.obs;
  Rx<User> self = User().obs;
  Rx<User> other = User().obs;
  RxList<Message> messages = <Message>[].obs;
  RxBool showEmoji = false.obs;

  late Chat chat;
  @override
  Future<void> onInit() async {
    messageController.addListener(() {
      message(messageController.text);
    });

    Map<String, dynamic> args = Get.arguments as Map<String, dynamic>;
    chat = args['chat'] as Chat;

    pagingController = PagingController<int, Message>(
      firstPageKey: 1,
    );
    pagingController?.addPageRequestListener((pageKey) {
      _fetchMessages(
        pageKey,
        10,
      );
    });

    await init();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    messageController.dispose();
    pagingController?.dispose();

    if (shouldRefresh) {
      chatController.getChats();
    }
    super.onClose();
  }

  Future<void> init() async {
    change(null, status: RxStatus.loading());
    try {
      self.value = User.fromJson(
        jsonDecode(
          await localRepository.get(
            LocalRepositoryKey.USER,
            '{}',
          ),
        ),
      );
      self.refresh();

      for (Participant participant in chat.participants ?? []) {
        if (participant.userId == self.value.id) {
          self.value = participant.user!;
          self.refresh();
        } else {
          other.value = participant.user!;
          other.refresh();
        }
      }

      chatName.value = other.value.name!;
      chatInitial.value = chatName
          .split(' ')
          .map(
            (word) => word[0],
          )
          .join('');
      change(null, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  Future<void> _fetchMessages(int page, int limit) async {
    try {
      final response = await messageRepository.getMessages(
        chatId: chat.id!,
        page: page,
        limit: limit,
      );

      if (response.meta!.code != 200) {
        pagingController?.error = response.meta!.messages!.first;
        return;
      }

      if (response.messages == null || response.messages?.isEmpty == true) {
        pagingController?.appendLastPage([]);
        return;
      }

      if (response.messages!.length < limit) {
        pagingController?.appendLastPage(response.messages!);
        return;
      }

      pagingController?.appendPage(
        response.messages!,
        page + 1,
      );
    } catch (e) {
      AppWidget.openSnackbar(
        'Oops! Something went wrong',
        'Failed to fetch messages. Please try again.',
      );
    }
  }

  Future<void> sendMessage() async {
    if (messageController.text.isEmpty || sending.value) {
      return;
    }

    sending(true);
    try {
      final response = await messageRepository.sendMessage(
        chat.id!,
        messageController.text,
      );

      // Dont add to appendLastPage directly
      // It will causing the new message at the top of screen, not bottom
      pagingController?.itemList?.insert(0, response.message!);
      pagingController?.appendLastPage([]);

      messageController.clear();
      message('');
      showEmoji(false);
      shouldRefresh = true;
    } catch (e) {
      AppWidget.openSnackbar(
        'Oops! Something went wrong',
        'Failed to send message. Please try again.',
      );
    } finally {
      sending(false);
    }
  }

  void showEmojiPicker() {
    hideKeyboard();
    showEmoji(!showEmoji.value);
  }

  void hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void onKeyboardState(KeyboardState state) {
    switch (state) {
      case KeyboardState.hiding:
        break;
      case KeyboardState.hidden:
        break;
      case KeyboardState.visibling:
        showEmoji(false);
        break;
      case KeyboardState.visible:
        break;
      default:
        break;
    }
  }
}
