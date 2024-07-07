import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:keyboard_detection/keyboard_detection.dart';

import '../../infrastructure/theme/app.color.dart';
import 'controllers/home.controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return KeyboardDetection(
      controller: KeyboardDetectionController(
        onChanged: controller.onKeyboardState,
      ),
      child: Scaffold(
        key: controller.scaffoldKey,
        resizeToAvoidBottomInset: true,
        extendBody: true,
        bottomNavigationBar: Theme(
          data: Get.theme.copyWith(
            bottomAppBarTheme: Get.theme.bottomAppBarTheme.copyWith(
              color: AppColor.primaryColor,
              elevation: 0,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: AppColor.primaryColor,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(80),
                topLeft: Radius.circular(80),
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(80),
                topLeft: Radius.circular(80),
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              child: BottomAppBar(
                clipBehavior: Clip.antiAlias,
                height: 93 - Get.mediaQuery.viewPadding.bottom,
                elevation: 0,
                padding: const EdgeInsets.only(
                  left: 32,
                  right: 32,
                  top: 18.5,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildBottomBarItem(
                      controller,
                      icon: 'assets/icons/home.svg',
                      activeIcon: 'assets/icons/home-active.svg',
                      label: 'Home',
                      index: 0,
                    ),
                    buildBottomBarItem(
                      controller,
                      icon: 'assets/icons/search.svg',
                      activeIcon: 'assets/icons/search-active.svg',
                      label: 'Search',
                      index: 1,
                    ),
                    buildBottomBarItem(
                      controller,
                      icon: 'assets/icons/books.svg',
                      activeIcon: 'assets/icons/books-active.svg',
                      label: 'Saved',
                      index: 2,
                    ),
                    buildBottomBarItem(
                      controller,
                      icon: 'assets/icons/chat.svg',
                      activeIcon: 'assets/icons/chat-active.svg',
                      label: 'Chat',
                      index: 3,
                    ),
                    buildBottomBarItem(
                      controller,
                      icon: 'assets/icons/profile.svg',
                      activeIcon: 'assets/icons/profile-active.svg',
                      label: 'Profile',
                      index: 4,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBottomBarItem(
    HomeController controller, {
    required String icon,
    required String activeIcon,
    required String label,
    required int index,
  }) {
    return Obx(
      () {
        // FirstChild is Active Icon, SecondChild is Inactive Icon
        Widget firstChild = AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 40,
          curve: Curves.easeInOutCubicEmphasized,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(100),
            shape: BoxShape.rectangle,
          ),
          child: IconButton(
            onPressed: () {
              controller.changePage(index);
            },
            style: ButtonStyle(
              splashFactory: NoSplash.splashFactory,
              padding: WidgetStateProperty.all(
                const EdgeInsets.only(
                  right: 16,
                  top: 8,
                  bottom: 8,
                  left: 8,
                ),
              ),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              enableFeedback: true,
              maximumSize: WidgetStateProperty.all(
                const Size(double.infinity, 40),
              ),
              elevation: WidgetStateProperty.resolveWith(
                (states) {
                  if (states.contains(WidgetState.pressed)) {
                    return 2;
                  }
                  return 0;
                },
              ),
            ),
            icon: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  activeIcon,
                  width: 24,
                  height: 24,
                ),
                if (controller.selectedIndex.value == index)
                  const SizedBox(width: 4),
                if (controller.selectedIndex.value == index)
                  Flexible(
                    child: Text(
                      label,
                      style: const TextStyle(
                        color: Color(0xFF6295A2),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),
        );
        Widget secondChild = AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 40,
          curve: Curves.easeInOutCubicEmphasized,
          decoration: const BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.transparent,
          ),
          child: IconButton(
            onPressed: () {
              controller.changePage(index);
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            style: ButtonStyle(
              splashFactory: NoSplash.splashFactory,
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              enableFeedback: true,
              maximumSize: WidgetStateProperty.all(
                const Size(double.infinity, 40),
              ),
              elevation: WidgetStateProperty.resolveWith(
                (states) {
                  if (states.contains(WidgetState.pressed)) {
                    return 2;
                  }
                  return 0;
                },
              ),
            ),
            icon: SvgPicture.asset(
              icon,
              width: 24,
              height: 24,
            ),
          ),
        );
        return AnimatedCrossFade(
          firstChild: firstChild,
          firstCurve: Curves.easeInOutCubicEmphasized,
          secondChild: secondChild,
          secondCurve: Curves.easeInOutCubic,
          crossFadeState: controller.selectedIndex.value == index
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 300),
        );
      },
    );
  }
}
