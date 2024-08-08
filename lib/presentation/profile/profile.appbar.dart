import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../infrastructure/navigation/routes.dart';
import '../../infrastructure/theme/app.color.dart';
import '../../infrastructure/theme/app.widget.dart';
import 'controllers/profile.controller.dart';

class ProfileAppBar extends SliverPersistentHeaderDelegate {
  final ProfileController controller = Get.find<ProfileController>();

  static final appBarColorTween = ColorTween(
    begin: Colors.transparent,
    end: AppColor.primaryColor,
  );
  static final appBarIconColorTween = ColorTween(
    begin: AppColor.primaryBlackColor,
    end: Colors.white,
  );
  static final appBarHeightTween = Tween<double>(
    begin: 400.0 + Get.mediaQuery.viewPadding.top + kToolbarHeight,
    end: kToolbarHeight + Get.mediaQuery.viewPadding.top,
  );
  static final profilePicTween = Tween<double>(
    begin: 121,
    end: 40,
  );
  static final buttonSizeTween = Tween<double>(
    begin: 36,
    end: 0,
  );
  static final textScalerTween = Tween<double>(
    begin: 1.0,
    end: 0.3,
  );

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final double deltaExtent = maxExtent - minExtent;

    final double t = clampDouble(
      1.0 - (shrinkOffset - minExtent) / deltaExtent,
      0.0,
      1.0,
    );

    final relativeScroll = min(shrinkOffset, 400) / 400;
    final double fadeStart = max(0.0, 1.0 - kToolbarHeight / deltaExtent);
    const double fadeEnd = 1.0;
    return FlexibleSpaceBarSettings(
      currentExtent: appBarHeightTween.transform(relativeScroll),
      minExtent: minExtent,
      maxExtent: maxExtent,
      toolbarOpacity: maxExtent == minExtent
          ? 1.0
          : 1.0 - Interval(fadeStart, fadeEnd).transform(t),
      hasLeading: false,
      child: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: appBarColorTween.transform(relativeScroll),
        systemOverlayStyle:
            appBarColorTween.transform(relativeScroll) == Colors.transparent
                ? const SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent,
                    statusBarIconBrightness: Brightness.dark,
                    statusBarBrightness: Brightness.light,
                    systemNavigationBarColor: AppColor.backgroundColor,
                    systemNavigationBarIconBrightness: Brightness.dark,
                  )
                : const SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent,
                    statusBarIconBrightness: Brightness.light,
                    statusBarBrightness: Brightness.dark,
                    systemNavigationBarColor: AppColor.backgroundColor,
                    systemNavigationBarIconBrightness: Brightness.dark,
                  ),
        actions: [
          SizedBox(
            child: IconButton(
              onPressed: () {
                Get.toNamed(Routes.POST);
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              style: const ButtonStyle(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              iconSize: 24,
              icon: SvgPicture.asset(
                'assets/icons/camera.svg',
                colorFilter: ColorFilter.mode(
                  appBarIconColorTween.transform(relativeScroll)!,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            child: Stack(
              children: [
                IconButton(
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  style: const ButtonStyle(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  iconSize: 24,
                  icon: SvgPicture.asset(
                    'assets/icons/notification.svg',
                    colorFilter: ColorFilter.mode(
                      appBarIconColorTween.transform(relativeScroll)!,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFFDE0639),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
        ],
        flexibleSpace: FlexibleSpaceBar(
          stretchModes: const [
            StretchMode.zoomBackground,
            StretchMode.fadeTitle,
            StretchMode.blurBackground
          ],
          centerTitle: false,
          titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
          title: AnimatedOpacity(
            alwaysIncludeSemantics: true,
            duration: 300.milliseconds,
            curve: Curves.easeInOutCirc,
            opacity: appBarHeightTween.transform(relativeScroll) == minExtent
                ? 1
                : 0,
            child: Text(
              controller.homeController.user.value.name ?? '',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: GoogleFonts.nunito().fontFamily,
              ),
            ),
          ),
          background: SafeArea(
            minimum: const EdgeInsets.only(
              left: 16,
              right: 16,
            ),
            bottom: false,
            child: Column(
              children: [
                const SizedBox(height: kToolbarHeight),
                SizedBox(
                  width: profilePicTween.transform(relativeScroll),
                  height: profilePicTween.transform(relativeScroll),
                  child: Obx(
                    () => AppWidget.imageBuilder(
                      imageURL: controller.homeController.user.value.photoURL,
                      gender: controller.homeController.user.value.gender,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Obx(
                  () => Text(
                    controller.homeController.user.value.name ?? '',
                    style: const TextStyle(
                      color: Color(0xFF3D405B),
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                    textScaler: TextScaler.linear(
                      textScalerTween.transform(relativeScroll),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Obx(
                  () => Text(
                    controller.homeController.user.value.username != null
                        ? '@${controller.homeController.user.value.username}'
                        : controller.homeController.user.value.email ?? '',
                    style: TextStyle(
                      color: const Color(0xFF3D405B),
                      fontSize: 16,
                      fontFamily: GoogleFonts.nunito().fontFamily,
                    ),
                    textScaler: TextScaler.linear(
                      textScalerTween.transform(relativeScroll),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/location.svg',
                    ),
                    const SizedBox(width: 4.45),
                    Text(
                      controller.location.isNotEmpty
                          ? '${controller.location['subAdministrativeArea'] ?? ''}, ${controller.location['administrativeArea'] ?? ''}'
                          : 'Unknown',
                      style: TextStyle(
                        color: const Color(0xFF3d6E99),
                        fontSize: 10.78,
                        fontWeight: FontWeight.w600,
                        fontFamily: GoogleFonts.inter().fontFamily,
                      ),
                      textScaler: TextScaler.linear(
                        textScalerTween.transform(relativeScroll),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(
                      () {
                        if (controller.homeController.user.value.instagram ==
                            null) {
                          return const SizedBox.shrink();
                        }

                        return IconButton(
                          iconSize: 24,
                          onPressed: () {
                            controller.openInstagram();
                          },
                          style: ButtonStyle(
                            padding: WidgetStateProperty.all(
                              const EdgeInsets.all(0),
                            ),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          padding: EdgeInsets.zero,
                          icon: SvgPicture.asset(
                            'assets/icons/instagram.svg',
                            width: 24,
                            height: 24,
                          ),
                        );
                      },
                    ),
                    Obx(
                      () {
                        if (controller.homeController.user.value.twitter ==
                            null) {
                          return const SizedBox.shrink();
                        }

                        return IconButton(
                          iconSize: 24,
                          onPressed: () {
                            controller.openX();
                          },
                          style: ButtonStyle(
                            padding: WidgetStateProperty.all(
                              const EdgeInsets.all(0),
                            ),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          padding: EdgeInsets.zero,
                          icon: SvgPicture.asset(
                            'assets/icons/x.svg',
                            width: 24,
                            height: 24,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                SizedBox(
                  height: buttonSizeTween.transform(relativeScroll),
                  child: MaterialButton(
                    onPressed: () {
                      Get.toNamed(Routes.EDIT_PROFILE);
                    },
                    color: AppColor.secondaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 0,
                    highlightElevation: 2,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 36,
                      vertical: 10,
                    ),
                    child: Text(
                      'Edit Profile',
                      style: TextStyle(
                        color: const Color(0xFFF4F1DE),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        fontFamily: GoogleFonts.nunito().fontFamily,
                      ),
                      textScaler: TextScaler.linear(
                        textScalerTween.transform(relativeScroll),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 48,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Column(
                          children: [
                            Text(
                              controller.state!['books'].length.toString(),
                              style: const TextStyle(
                                color: AppColor.primaryBlackColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                              textScaler: TextScaler.linear(
                                textScalerTween.transform(relativeScroll),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Collection',
                              style: const TextStyle(
                                color: Color(0xFF3D405B),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              textScaler: TextScaler.linear(
                                textScalerTween.transform(relativeScroll),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // FittedBox(
                      //   fit: BoxFit.scaleDown,
                      //   child: Column(
                      //     children: [
                      //       Text(
                      //         '0',
                      //         style: const TextStyle(
                      //           color: AppColor.primaryBlackColor,
                      //           fontSize: 18,
                      //           fontWeight: FontWeight.w700,
                      //         ),
                      //         textScaler: TextScaler.linear(
                      //           textScalerTween.transform(relativeScroll),
                      //         ),
                      //       ),
                      //       const SizedBox(height: 4),
                      //       Text(
                      //         'Followers',
                      //         style: const TextStyle(
                      //           color: Color(0xFF3D405B),
                      //           fontSize: 16,
                      //           fontWeight: FontWeight.w600,
                      //         ),
                      //         textScaler: TextScaler.linear(
                      //           textScalerTween.transform(relativeScroll),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // FittedBox(
                      //   fit: BoxFit.scaleDown,
                      //   child: Column(
                      //     children: [
                      //       Text(
                      //         '0',
                      //         style: const TextStyle(
                      //           color: AppColor.primaryBlackColor,
                      //           fontSize: 18,
                      //           fontWeight: FontWeight.w700,
                      //         ),
                      //         textScaler: TextScaler.linear(
                      //           textScalerTween.transform(relativeScroll),
                      //         ),
                      //       ),
                      //       const SizedBox(height: 4),
                      //       Text(
                      //         'Following',
                      //         style: const TextStyle(
                      //           color: Color(0xFF3D405B),
                      //           fontSize: 16,
                      //           fontWeight: FontWeight.w600,
                      //         ),
                      //         textScaler: TextScaler.linear(
                      //           textScalerTween.transform(relativeScroll),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0xFF3D6E99),
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent =>
      400.0 + Get.mediaQuery.viewPadding.top + kToolbarHeight;

  @override
  double get minExtent => kToolbarHeight + Get.mediaQuery.viewPadding.top;

  @override
  bool shouldRebuild(ProfileAppBar oldDelegate) {
    return true;
  }

  @override
  OverScrollHeaderStretchConfiguration get stretchConfiguration =>
      OverScrollHeaderStretchConfiguration(
        stretchTriggerOffset: maxExtent,
      );
}
