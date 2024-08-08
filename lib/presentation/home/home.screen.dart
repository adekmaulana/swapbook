import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../../infrastructure/navigation/routes.dart';
import '../../infrastructure/theme/app.color.dart';
import '../../infrastructure/theme/app.widget.dart';
import 'controllers/home.controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      resizeToAvoidBottomInset: true,
      extendBody: true,
      backgroundColor: AppColor.backgroundColor,
      drawer: Drawer(
        width: Get.width * 0.55,
        backgroundColor: AppColor.backgroundColor,
        child: SafeArea(
          minimum: const EdgeInsets.only(
            left: 24,
            right: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: AppBar().preferredSize.height,
                width: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: Obx(
                        () => AppWidget.imageBuilder(
                          imageURL: controller.user.value.photoURL,
                          gender: controller.user.value.gender,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Obx(
                              () => Text(
                                controller.user.value.name ?? '',
                                style: const TextStyle(
                                  color: AppColor.primaryBlackColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Obx(
                              () => Text(
                                controller.user.value.username ??
                                    controller.user.value.email!,
                                style: const TextStyle(
                                  color: AppColor.borderColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  Get.toNamed(
                    Routes.EDIT_PROFILE,
                  );
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                style: const ButtonStyle(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  splashFactory: NoSplash.splashFactory,
                ),
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                iconSize: 20,
                icon: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/setting.svg',
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Setting',
                      style: TextStyle(
                        color: AppColor.primaryBlackColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 26),
              IconButton(
                onPressed: () async {
                  await controller.logout();
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                style: const ButtonStyle(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  splashFactory: NoSplash.splashFactory,
                ),
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                iconSize: 20,
                icon: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/logout.svg',
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Sign Out',
                      style: TextStyle(
                        color: Color(0xFFFF8686),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: kBottomNavigationBarHeight),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Theme(
        data: Get.theme.copyWith(
          bottomAppBarTheme: Get.theme.bottomAppBarTheme.copyWith(
            color: AppColor.primaryColor,
            elevation: 0,
          ),
        ),
        child: Obx(
          () {
            if (controller.onLoad()) {
              return const SizedBox.shrink();
            }

            return Container(
              decoration: const BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.only(
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
                  height: 93 - MediaQuery.of(context).padding.bottom,
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
            );
          },
        ),
      ),
      // logout,
      body: controller.obx(
        (state) => PageView(
          controller: controller.pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: controller.pages,
          onPageChanged: (index) {
            controller.selectedIndex(index);
          },
        ),
        onLoading: Center(
          child: AppWidget.getLoadingIndicator(
            color: AppColor.primaryColor,
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
