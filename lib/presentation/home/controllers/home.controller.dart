import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData;
import 'package:location/location.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../../data/models/chat.model.dart';
import '../../../data/models/user.model.dart';
import '../../../domain/case/auth/logout.case.dart';
import '../../../domain/case/auth/ping.case.dart';
import '../../../domain/case/user/update_location.case.dart';
import '../../../infrastructure/constant.dart';
import '../../../infrastructure/navigation/routes.dart';
import '../../../infrastructure/services/location.service.dart';
import '../../../infrastructure/services/pusher.service.dart';
import '../../chat/controllers/chat.controller.dart';
import '../../controller.dart.dart';
import '../../screens.dart';

class HomeController extends BaseController with StateMixin<LocationData> {
  PageController pageController = PageController();
  LocationService locationService = Get.find<LocationService>();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  ChatController? chatController;
  StreamSubscription? timerSubscription;
  Chat? selectedChat;
  Timer? _notificationDebounce;

  RxInt selectedIndex = 0.obs;
  Rx<User> user = User().obs;
  RxBool onLoad = false.obs;

  String tagName = 'user_id';

  List<Widget> pages = const [
    KatalogScreen(),
    SearchScreen(),
    BookmarksScreen(),
    ChatScreen(),
    ProfileScreen(),
  ];

  @override
  void onInit() async {
    onLoad(true);
    change(null, status: RxStatus.loading());
    super.onInit();

    user.value = User.fromJson(jsonDecode(
      await localRepository.get(
        LocalRepositoryKey.USER,
        '{}',
      ),
    ));

    final token = await localRepository.get(
      LocalRepositoryKey.TOKEN,
      '',
    );

    if (token.isEmpty) {
      return;
    }

    await OneSignal.User.addTagWithKey(tagName, user.value.id.toString());
    setupCallbackOneSignal();

    final location = await locationService.requestLocation();
    if (location == null) {
      change(null, status: RxStatus.success());
      return;
    }

    UpdateLocationUserCase().call(
      FormData.fromMap(
        {
          'latitude': location.latitude,
          'longitude': location.longitude,
          'accuracy': location.accuracy,
          'altitude': location.altitude,
          'speed': location.speed,
          'speed_accuracy': location.speedAccuracy,
          'heading': location.heading,
          'time': location.time,
          'is_mock': location.isMock == true ? 1 : 0,
          'vertical_accuracy': location.verticalAccuracy,
          'heading_accuracy': location.headingAccuracy,
          'elapsed_realtime_nanos': location.elapsedRealtimeNanos,
          'elapsed_realtime_uncertainty_nanos':
              location.elapsedRealtimeUncertaintyNanos,
          'satellite_number': location.satelliteNumber,
          'provider': location.provider,
        },
      ),
    );

    change(location, status: RxStatus.success());
    user.value.location = location;
    user.refresh();

    chatController = Get.find<ChatController>();

    // timerSubscription = Stream.periodic(30.seconds, (int count) {
    //   ping();
    // }).listen((event) {});
    onLoad(false);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    pageController.dispose();
    // timerSubscription?.cancel();
    super.onClose();
  }

  void changePage(int index) {
    selectedIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOutCirc,
    );
  }

  Future<void> logout() async {
    try {
      await AuthLogoutCase().call();

      await localRepository.removeAll();
      await deleteUserTag();
      EchoService.instance.disconnect();

      Get.offAllNamed(Routes.WELCOME);
    } catch (e) {
      await localRepository.removeAll();

      return Get.offAllNamed(Routes.WELCOME);
    }
  }

  Future<void> ping() async {
    try {
      await AuthPingCase().call();
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
          await localRepository.removeAll();

          return Get.offAllNamed(Routes.WELCOME);
        }
      }
    }
  }

  void setupCallbackOneSignal() async {
    registerOneSignalEventListener(
      onOpened: (OSNotificationClickEvent event) async {
        try {
          final data = event.notification.additionalData;
          if (data != null) {
            int chatId = data['data']['chat_id'];
            if (chatId != selectedChat?.id) {
              if (selectedChat != null) {
                Get.offAndToNamed(
                  Routes.CHAT_ROOM,
                  arguments: {
                    'chat': Chat(id: chatId),
                    'is_from_notification': true,
                  },
                );
              } else {
                Get.toNamed(
                  Routes.CHAT_ROOM,
                  arguments: {
                    'chat': Chat(id: chatId),
                    'is_from_notification': true,
                  },
                );
              }
            }
          }
        } catch (e) {
          print(e);
        }
      },
      onReceivedInForeground: (OSNotificationWillDisplayEvent event) {
        try {
          final data = event.notification.additionalData;
          if (data != null && selectedChat != null) {
            int chatId = data['data']['chat_id'];
            if (chatId == selectedChat!.id) {
              return event.preventDefault();
            }
          }

          chatController!.pagingController?.refresh();
        } catch (e) {
          return event.preventDefault();
        }
      },
    );
  }

  void registerOneSignalEventListener({
    required Function(OSNotificationClickEvent) onOpened,
    required Function(OSNotificationWillDisplayEvent) onReceivedInForeground,
  }) {
    OneSignal.Notifications.addClickListener(onOpened);
    OneSignal.Notifications.addForegroundWillDisplayListener(
      onReceivedInForeground,
    );
  }

  Future<void> sendUserTag(String userId) async {
    await OneSignal.User.addTagWithKey(tagName, userId);
  }

  Future<void> deleteUserTag() async {
    await OneSignal.User.removeTag(tagName);
  }
}
