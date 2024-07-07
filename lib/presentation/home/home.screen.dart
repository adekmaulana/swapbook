import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:keyboard_detection/keyboard_detection.dart';

import '../../infrastructure/theme/app.color.dart';
import '../../infrastructure/theme/app.widget.dart';
import 'controllers/home.controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  static const FloatingActionButtonLocation centerDocked =
      _CenterDockedFabLocation();
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
        floatingActionButton: Obx(
          () => Visibility(
            visible: controller.isFabVisible.value,
            child: FloatingActionButton(
              heroTag: "<createPost FloatingActionButton tag>",
              onPressed: () {},
              backgroundColor: AppColor.primaryColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(110),
                ),
              ),
              elevation: 8,
              child: const Icon(
                Icons.add_rounded,
                size: 32,
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: centerDocked,
        bottomNavigationBar: Theme(
          data: Get.theme.copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            bottomAppBarTheme: Get.theme.bottomAppBarTheme.copyWith(
              color: Colors.white.withAlpha(255),
              elevation: 0,
              shape: const CircularNotchedRectangle(),
              surfaceTintColor: Colors.white.withAlpha(255),
            ),
          ),
          child: BottomAppBar(
            height: 60,
            clipBehavior: Clip.antiAlias,
            elevation: 0,
            notchMargin: 2.88,
            padding: const EdgeInsets.only(
              left: 8,
              right: 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildBottomBarItem(
                  controller,
                  icon: "assets/icons/home.svg",
                  label: 'Home',
                  index: 0,
                ),
              ],
            ),
          ),
        ),
        body: LayoutBuilder(
          builder: (
            BuildContext context,
            BoxConstraints constraints,
          ) {
            controller.isPotrait.value = MediaQuery.of(
                  context,
                ).orientation ==
                Orientation.portrait;
            return SizedBox(
              // button logout
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: MaterialButton(
                onPressed: () async {
                  await controller.logout();
                },
                color: AppColor.secondaryColor,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                enableFeedback: true,
                highlightElevation: 2,
                elevation: 0,
                child: const Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildBottomBarItem(
    HomeController controller, {
    required String icon,
    required String label,
    required int index,
  }) {
    var activeText = Text(
      label,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 11,
        height: 0.09,
      ),
    );
    var inactiveText = Text(
      label,
      style: const TextStyle(
        color: AppColor.greyTextColor,
        fontWeight: FontWeight.w500,
        fontSize: 11,
        height: 0.09,
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Obx(
            () {
              if (controller.selectedIndex.value == index) {
                return SvgPicture.asset(
                  icon,
                  width: 24,
                  height: 24,
                );
              }

              return SvgPicture.asset(
                icon,
                width: 24,
                height: 24,
              );
            },
          ),
          onPressed: () {
            controller.changePage(index);
          },
        ),
        Obx(
          () => controller.selectedIndex.value == index
              ? activeText
              : inactiveText,
        ),
      ],
    );
  }
}

class _CenterDockedFabLocation extends StandardFabLocation
    with FabCenterOffsetX, _FabDockedOffsetY {
  const _CenterDockedFabLocation();

  @override
  String toString() => 'FloatingActionButtonLocation.centerDocked';
}

class _CenterDockedFloatingActionButtonLocation
    extends _DockedFloatingActionButtonLocation {
  const _CenterDockedFloatingActionButtonLocation();

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final double fabX = (scaffoldGeometry.scaffoldSize.width -
            scaffoldGeometry.floatingActionButtonSize.width) /
        2.0;
    return Offset(fabX, getDockedY(scaffoldGeometry));
  }
}

mixin _FabCenterOffsetX on StandardFabLocation {
  @override
  double getOffsetX(
      ScaffoldPrelayoutGeometry scaffoldGeometry, double adjustment) {
    return (scaffoldGeometry.scaffoldSize.width -
            scaffoldGeometry.floatingActionButtonSize.width) /
        2.0;
  }
}

mixin _FabDockedOffsetY on StandardFabLocation {
  /// Calculates y-offset for [FloatingActionButtonLocation]s floating over the
  /// [Scaffold.bottomNavigationBar] so that the center of the floating
  /// action button lines up with the top of the bottom navigation bar.
  @override
  double getOffsetY(
      ScaffoldPrelayoutGeometry scaffoldGeometry, double adjustment) {
    final double contentBottom = scaffoldGeometry.contentBottom + 10;
    final double contentMargin =
        scaffoldGeometry.scaffoldSize.height - contentBottom;
    final double bottomViewPadding = scaffoldGeometry.minViewPadding.bottom;
    final double bottomSheetHeight = scaffoldGeometry.bottomSheetSize.height;
    final double fabHeight = scaffoldGeometry.floatingActionButtonSize.height;
    final double snackBarHeight = scaffoldGeometry.snackBarSize.height;
    final double bottomMinInset = scaffoldGeometry.minInsets.bottom;

    double safeMargin;

    if (contentMargin > bottomMinInset + fabHeight / 2.0) {
      // If contentMargin is higher than bottomMinInset enough to display the
      // FAB without clipping, don't provide a margin
      safeMargin = 0.0;
    } else if (bottomMinInset == 0.0) {
      // If bottomMinInset is zero(the software keyboard is not on the screen)
      // provide bottomViewPadding as margin
      safeMargin = bottomViewPadding;
    } else {
      // Provide a margin that would shift the FAB enough so that it stays away
      // from the keyboard
      safeMargin = fabHeight / 2.0 + kFloatingActionButtonMargin;
    }

    double fabY = contentBottom - fabHeight / 2.0 - safeMargin;
    // The FAB should sit with a margin between it and the snack bar.
    if (snackBarHeight > 0.0) {
      fabY = math.min(
          fabY,
          contentBottom -
              snackBarHeight -
              fabHeight -
              kFloatingActionButtonMargin);
    }
    // The FAB should sit with its center in front of the top of the bottom sheet.
    if (bottomSheetHeight > 0.0) {
      fabY =
          math.min(fabY, contentBottom - bottomSheetHeight - fabHeight / 2.0);
    }
    final double maxFabY =
        scaffoldGeometry.scaffoldSize.height - fabHeight - safeMargin - 10;
    return math.min(maxFabY, fabY);
  }
}

abstract class _DockedFloatingActionButtonLocation
    extends FloatingActionButtonLocation {
  const _DockedFloatingActionButtonLocation();
  @protected
  double getDockedY(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final double contentBottom = scaffoldGeometry.contentTop + 10;
    final double appBarHeight = scaffoldGeometry.bottomSheetSize.height;
    final double fabHeight = scaffoldGeometry.floatingActionButtonSize.height;
    final double snackBarHeight = scaffoldGeometry.snackBarSize.height;

    double fabY = contentBottom - fabHeight / 2.0;
    if (snackBarHeight > 0.0) {
      fabY = math.min(
          fabY,
          contentBottom -
              snackBarHeight -
              fabHeight -
              kFloatingActionButtonMargin);
    }
    if (appBarHeight > 0.0) {
      fabY = math.min(fabY, contentBottom - appBarHeight - fabHeight / 2.0);
    }

    final double maxFabY = scaffoldGeometry.scaffoldSize.height - fabHeight;
    return math.min(maxFabY, fabY);
  }
}
