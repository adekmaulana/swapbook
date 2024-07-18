import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/case/auth/logout.case.dart';
import '../../../domain/case/auth/ping.case.dart';
import '../../../infrastructure/navigation/routes.dart';
import '../../controller.dart.dart';
import '../../screens.dart';

class HomeController extends BaseController with StateMixin<bool> {
  PageController pageController = PageController();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  StreamSubscription? timerSubscription;
  bool isBottomSheetOpen = false;
  bool isDialogOpen = false;

  RxDouble keyboardHeight = 0.0.obs;
  RxBool keyboardOpened = false.obs;
  RxInt selectedIndex = 0.obs;
  RxBool isPotrait = true.obs;

  List<Widget> pages = const [
    KatalogScreen(),
    SearchScreen(),
    BookmarksScreen(),
    ChatScreen(),
    ProfileScreen(),
  ];

  @override
  void onInit() async {
    super.onInit();

    // timerSubscription = Stream.periodic(30.seconds, (int count) {
    //   ping();
    // }).listen((event) {});
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
}
