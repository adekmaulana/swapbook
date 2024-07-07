import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_detection/keyboard_detection.dart';

import '../../../domain/case/auth/logout.case.dart';
import '../../../infrastructure/navigation/routes.dart';
import '../../controller.dart.dart';

class HomeController extends BaseController with StateMixin<bool> {
  PageController pageController = PageController();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isBottomSheetOpen = false;
  bool isDialogOpen = false;

  RxDouble keyboardHeight = 0.0.obs;
  RxBool keyboardOpened = false.obs;
  RxInt selectedIndex = 0.obs;
  RxBool isFabVisible = false.obs;
  RxString currentRoute = '/home'.obs;
  RxInt notificationCount = 0.obs;
  RxBool isPotrait = true.obs;

  List<Widget> pages = const [];

  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void changePage(int index) {
    selectedIndex.value = index;
    Get.nestedKey(index + 1)?.currentState?.popUntil((route) {
      currentRoute.value = route.settings.name ?? Routes.HOME;
      return true;
    });

    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCirc,
    );
  }

  void onKeyboardState(KeyboardState state) {
    switch (state) {
      case KeyboardState.hiding:
        isFabVisible.value = true;
        break;
      case KeyboardState.hidden:
        keyboardOpened.value = false;
        keyboardHeight.value = 0.0;
        break;
      case KeyboardState.visibling:
        isFabVisible.value = false;
        break;
      case KeyboardState.visible:
        keyboardOpened.value = true;
        keyboardHeight.value = Get.mediaQuery.viewInsets.bottom;
        break;
      default:
        break;
    }
  }

  void pop({dynamic result, int? id}) {
    int key = id ?? selectedIndex.value + 1;
    Get.back(
      result: result,
      id: key,
    );
    Get.nestedKey(key)?.currentState?.popUntil((currentRoute) {
      this.currentRoute.value = currentRoute.settings.name ?? Routes.HOME;
      return true;
    });
  }

  Future<void> logout() async {
    try {
      await AuthLogoutCase().call();

      await localRepository.removeAll();

      Get.offAllNamed(Routes.WELCOME);
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 401) {
          await localRepository.removeAll();

          return Get.offAllNamed(Routes.WELCOME);
        }
      }

      rethrow;
    }
  }
}
