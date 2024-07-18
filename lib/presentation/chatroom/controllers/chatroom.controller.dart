import 'dart:convert';
import 'dart:developer';

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
import '../../../infrastructure/services/pusher.service.dart';
import '../../../infrastructure/theme/app.widget.dart';
import '../../chat/controllers/chat.controller.dart';

class ChatroomController extends GetxController with StateMixin {
  TextEditingController messageController = TextEditingController();
  LocalRepository localRepository = Get.find<LocalRepository>();
  MessageRepository messageRepository = MessageRepository();
  PagingController<int, Message>? pagingController;
  ChatController chatController = Get.find<ChatController>();

  RxString chatInitial = ''.obs;
  RxString chatName = ''.obs;
  RxString message = ''.obs;
  RxBool sending = false.obs;
  Rx<User> self = User().obs;
  Rx<User> other = User().obs;
  RxList<Message> messages = <Message>[].obs;
  RxBool showEmoji = false.obs;
  RxBool isOnline = false.obs;

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
      _fetchMessages(pageKey, 10);
    });

    await init();
    await readMessages();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    disconnectChat(chat);
    messageController.dispose();
    pagingController?.dispose();

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

      await initEcho();
      chatController.pagingController?.itemList?.forEach((element) {
        if (element.id == chat.id) {
          int index =
              chatController.pagingController?.itemList?.indexOf(element) ?? 0;
          if (chatController.pagingController?.itemList?.remove(element) ==
              true) {
            chatController.pagingController?.itemList?.insert(index, chat);
            chatController.pagingController?.appendLastPage([]);
          }
        }
      });
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
      pagingController?.error = e;
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
        EchoService.instance.socketId,
      );

      // Dont add to appendLastPage directly
      // It will causing the new message at the top of screen, not bottom
      pagingController?.itemList?.insert(0, response.message!);
      pagingController?.appendLastPage([]);

      chatController.pagingController?.itemList?.forEach((element) {
        if (element.id == chat.id) {
          if (chatController.pagingController?.itemList?.remove(element) ==
              true) {
            chat.lastMessage = response.message;
            chatController.pagingController?.itemList?.insert(0, chat);
            chatController.pagingController?.appendLastPage([]);
          }
        }
      });

      messageController.clear();
      message('');
      showEmoji(false);
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

  void listenChat(Chat chat) {
    EchoService.instance.private('chat.${chat.id}').listen('.message.sent',
        (e) {
      if (e != null) {
        _onMessageReceived(jsonDecode(e));
      }
    }).error(
      (error) {
        log(error.toString());
      },
    );
  }

  void disconnectChat(Chat chat) {
    EchoService.instance.leave('chat.${chat.id}');
    EchoService.instance.disconnect();
  }

  void _onMessageReceived(Map<String, dynamic> data) {
    final Message message = Message.fromJson(data['message']);
    if (data['chat_id'] == chat.id) {
      // Dont add to appendLastPage directly
      // It will causing the new message at the top of screen, not bottom
      pagingController?.itemList?.insert(0, message);
      pagingController?.appendLastPage([]);

      chatController.pagingController?.itemList?.forEach((element) {
        if (element.id == data['chat_id']) {
          if (chatController.pagingController?.itemList?.remove(element) ==
              true) {
            chat.lastMessage = message;
            chatController.pagingController?.itemList?.insert(0, chat);
            chatController.pagingController?.appendLastPage([]);
          }
        }
      });
    }
  }

  Future<void> initEcho() async {
    final token = await localRepository.get(
      LocalRepositoryKey.TOKEN,
      '',
    );

    if (token.isEmpty) {
      return;
    }

    EchoService.init(token);
    listenChat(chat);
  }

  Future<void> readMessages() async {
    try {
      await messageRepository.readMessages(chat.id!);
    } catch (e) {
      rethrow;
    }
  }
}
