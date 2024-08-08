import 'dart:convert';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:keyboard_detection/keyboard_detection.dart';

import '../../../data/models/chat.model.dart';
import '../../../data/models/message.model.dart';
import '../../../data/models/user.model.dart';
import '../../../data/repositories/local.repository.dart';
import '../../../domain/case/chat/get_chat.case.dart';
import '../../../domain/case/message/edit_message.case.dart';
import '../../../domain/case/message/get_messages.case.dart';
import '../../../domain/case/message/read_messages.case.dart';
import '../../../domain/case/message/send_message.case.dart';
import '../../../infrastructure/constant.dart';
import '../../../infrastructure/services/pusher.service.dart';
import '../../../infrastructure/theme/app.widget.dart';
import '../../chat/controllers/chat.controller.dart';
import '../../home/controllers/home.controller.dart';

class ChatroomController extends GetxController with StateMixin {
  TextEditingController messageController = TextEditingController();
  LocalRepository localRepository = Get.find<LocalRepository>();
  PagingController<int, Message>? pagingController;
  ChatController chatController = Get.find<ChatController>();
  HomeController homeController = Get.find<HomeController>();

  RxString chatInitial = ''.obs;
  RxString chatName = ''.obs;
  RxString message = ''.obs;
  RxBool sending = false.obs;
  Rx<User> user = User().obs;
  RxList<Message> messages = <Message>[].obs;
  RxBool showEmoji = false.obs;
  RxBool isOnline = false.obs;

  late Chat chat;
  @override
  Future<void> onInit() async {
    messageController.addListener(() {
      message(messageController.text);
    });
    pagingController = PagingController<int, Message>(
      firstPageKey: 1,
    );
    pagingController?.addPageRequestListener((pageKey) {
      _fetchMessages(pageKey, 10);
    });

    Map<String, dynamic> args = Get.arguments as Map<String, dynamic>;
    bool isFromNotification = args['is_from_notification'] ?? false;
    chat = args['chat'] as Chat;
    if (isFromNotification) {
      final response = await GetChatCase().call(chat.id!);
      if (response.meta!.code != 200) {
        pagingController?.error = response.meta!.messages!.first;
        return;
      }

      chat = response.chat!;
      user.value = chat.participants!
          .firstWhere(
            (element) => element.user!.id != homeController.user.value.id,
          )
          .user!;
    } else {
      user.value = args['user'] as User;
    }

    homeController.selectedChat = chat;
    user.refresh();

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
    homeController.selectedChat = null;
    chatController.pagingController?.refresh();

    super.onClose();
  }

  Future<void> init() async {
    change(null, status: RxStatus.loading());
    try {
      await initEcho();
      chatController.pagingController?.refresh();
      change(null, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  Future<void> _fetchMessages(int page, int pageSize) async {
    try {
      final response = await GetMessagesCase().call(
        chat.id!,
        page,
        pageSize,
      );

      if (response.meta!.code != 200) {
        pagingController?.error = response.meta!.messages!.first;
        return;
      }

      if (response.messages == null || response.messages?.isEmpty == true) {
        pagingController?.appendLastPage([]);
        return;
      }

      if (response.messages!.length < pageSize) {
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
      final response = await SendMessageCase().call(
        chat.id!,
        messageController.text,
        EchoService.instance.socketId,
      );

      messageController.clear();
      message('');
      showEmoji(false);

      // Dont add to appendLastPage directly
      // It will causing the new message at the top of screen, not bottom
      pagingController?.itemList?.insert(0, response.message!);
      pagingController?.appendLastPage([]);

      // Update last message in chat list
      chatController.pagingController?.refresh();

      homeController.user.value = response.message!.user!;
      homeController.user.refresh();
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
  }

  void _onMessageReceived(Map<String, dynamic> data) {
    final Message message = Message.fromJson(data['message']);
    user(message.user!);
    user.refresh();
    if (data['chat_id'] == chat.id) {
      // Dont add to appendLastPage directly
      // It will causing the new message at the top of screen, not bottom
      pagingController?.itemList?.insert(0, message);
      pagingController?.appendLastPage([]);

      // Update last message in chat list
      chatController.pagingController?.refresh();
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
    // final pusher = await PusherService.initialize(token);
    // await pusher.client.subscribe(
    //   channelName: 'private-chat.${chat.id}',
    // );
    // await pusher.client.connect();
    listenChat(chat);
  }

  Future<void> readMessages() async {
    try {
      await ReadMessagesCase().call(chat.id!);
      // Update last message in chat list
      chatController.pagingController?.refresh();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> approveRequest(int messageId, int requestId) async {
    try {
      final response = await EditMessageCase().call(
        messageId,
        {
          'status': 'approved',
          'request_id': requestId,
          'content': 'Request approved',
        },
      );

      pagingController?.refresh();

      homeController.user.value = response.message!.user!;
      homeController.user.refresh();
    } catch (e) {
      AppWidget.openSnackbar(
        'Oops! Something went wrong',
        'Failed to send message. Please try again.',
      );
    }
  }

  Future<void> rejectRequest(int messageId, int requestId) async {
    try {
      final response = await EditMessageCase().call(
        messageId,
        {
          'status': 'declined',
          'request_id': requestId,
          'content': 'Request declined',
        },
      );

      pagingController?.refresh();

      homeController.user.value = response.message!.user!;
      homeController.user.refresh();
    } catch (e) {
      AppWidget.openSnackbar(
        'Oops! Something went wrong',
        'Failed to send message. Please try again.',
      );
    }
  }
}
