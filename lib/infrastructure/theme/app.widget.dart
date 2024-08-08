import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import 'app.color.dart';

enum SnackBarStatus {
  error,
  success,
  warning,
}

class AppWidget {
  AppWidget._();

  static final Map<SnackBarStatus, Color> _color = {
    SnackBarStatus.error: AppColor.errorColor,
    SnackBarStatus.success: AppColor.successColor,
    SnackBarStatus.warning: AppColor.warningColor,
  };

  static final Map<SnackBarStatus, Color> _textColor = {
    SnackBarStatus.error: AppColor.baseWhiteColor,
    SnackBarStatus.success: AppColor.baseBlackColor,
    SnackBarStatus.warning: AppColor.baseBlackColor,
  };

  static final List<String> _defaultImage = [
    'assets/images/avatar-man.png',
    'assets/images/avatar-woman.png',
  ];

  static SnackbarController openSnackbar(
    String title,
    String message, {
    SnackBarStatus type = SnackBarStatus.error,
    VoidCallback? onPressed,
    Duration? duration,
  }) {
    return Get.snackbar(
      '',
      '',
      titleText: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: _textColor[type],
        ),
      ),
      messageText: Text(
        message,
        style: TextStyle(
          fontSize: 14,
          color: _textColor[type],
        ),
      ),
      duration: duration ?? const Duration(seconds: 3),
      snackPosition: SnackPosition.BOTTOM,
      colorText: _textColor[type],
      backgroundColor: _color[type],
      borderRadius: 10,
      padding: const EdgeInsets.only(
        top: 20,
        left: 20,
        bottom: 20,
        right: 28,
      ),
      margin: const EdgeInsets.only(
        bottom: kBottomNavigationBarHeight / 2,
        left: 16,
        right: 16,
      ),
      boxShadows: const [
        BoxShadow(
          color: Color(0x1A000000),
          blurRadius: 6,
          spreadRadius: -4,
          offset: Offset(0, 4),
        ),
        BoxShadow(
          color: Color(0x1A000000),
          blurRadius: 15,
          spreadRadius: -3,
          offset: Offset(0, 10),
        ),
      ],
      mainButton: (onPressed != null)
          ? TextButton(
              onPressed: onPressed,
              style: ButtonStyle(
                shape: WidgetStateProperty.resolveWith<OutlinedBorder?>(
                  (Set<WidgetState> states) {
                    return RoundedRectangleBorder(
                      side: BorderSide(
                        color: AppColor.neutralColor[200]!,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(36),
                      ),
                    );
                  },
                ),
              ),
              child: Text(
                'Try again',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _textColor[type],
                ),
              ),
            )
          : null,
    );
  }

  static Widget getLoadingIndicator({
    Color? color,
    double sizeIOS = 10.0,
    double sizeAndroid = 16.0,
  }) {
    return Platform.isIOS
        ? CupertinoActivityIndicator(
            color: color ?? AppColor.secondaryColor,
            radius: sizeIOS,
          )
        : SizedBox(
            width: sizeAndroid,
            height: sizeAndroid,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? AppColor.secondaryColor,
              ),
              strokeWidth: 2.0,
            ),
          );
  }

  static Future<T?> showBottomSheet<T>({
    String? routeName,
    dynamic arguments,
    bool removeBackground = false,
    required Widget child,
  }) async {
    return Get.bottomSheet<T>(
      isScrollControlled: true,
      settings: RouteSettings(
        name: routeName,
        arguments: arguments,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      Container(
        height: Get.height - Get.mediaQuery.viewPadding.top,
        decoration: BoxDecoration(
          color: AppColor.backgroundColor,
          image: !removeBackground
              ? DecorationImage(
                  image: Image.asset(
                    'assets/images/background-bottomsheet.png',
                    scale: 4,
                  ).image,
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    AppColor.backgroundColor.withOpacity(0.08),
                    BlendMode.hardLight,
                  ),
                )
              : null,
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.25),
              blurRadius: 4.35,
              offset: Offset(0, 4.35),
            ),
          ],
        ),
        child: child,
      ),
    );
  }

  static Future<bool> getPermissionAwareDialog() async {
    PermissionStatus status = await Permission.notification.status;

    if (status.isDenied) {
      status = await Permission.notification.request();
      if (status.isGranted || status.isProvisional) {
        await OneSignal.consentGiven(status.isGranted || status.isProvisional);
        return true;
      }
    }

    if (status.isPermanentlyDenied || status.isRestricted) {
      await OneSignal.consentGiven(false);
      return await Get.dialog(
        AlertDialog(
          backgroundColor: AppColor.backgroundColor,
          icon: Icon(
            Icons.notifications_on_rounded,
            color: AppColor.secondaryColor,
          ),
          title: const Text(
            'Allow “SwapBook” to send you notification',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 17,
              color: AppColor.primaryBlackColor,
            ),
            textAlign: TextAlign.center,
          ),
          content: const Text(
            'If you ever denied notifications prompt before, to turn on notifications again just visit the app settings.',
            style: TextStyle(
              fontSize: 14,
              color: AppColor.primaryBlackColor,
            ),
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () {
                Get.back(result: false);
              },
              child: SizedBox(
                width: Get.mediaQuery.size.width * 0.2,
                child: Text(
                  'Skip',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColor.primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                await openAppSettings();
                Get.back(result: false);
              },
              child: SizedBox(
                width: Get.mediaQuery.size.width * 0.2,
                child: Text(
                  'Setting',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColor.secondaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    }

    return true;
  }

  static Widget imageBuilder({
    String? imageURL,
    String? gender,
  }) {
    return CachedNetworkImage(
      imageUrl: imageURL ?? '',
      imageBuilder: (context, imageProvider) => InkWell(
        onLongPress: () {
          showImageViewer(
            context,
            imageProvider,
            swipeDismissible: true,
            doubleTapZoomable: true,
            useSafeArea: true,
            backgroundColor: Colors.transparent,
            closeButtonColor: AppColor.primaryBlackColor,
          );
        },
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        customBorder: const CircleBorder(),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      placeholder: (context, url) => getLoadingIndicator(
        color: AppColor.primaryColor,
      ),
      errorWidget: (context, url, error) => defaultImageBuilder(
        gender: gender,
      ),
    );
  }

  static Widget defaultImageBuilder({
    String? gender,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColor.backgroundImageColor2,
        image: DecorationImage(
          image: AssetImage(_defaultImage[0]),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class BaseView extends StatelessWidget {
  const BaseView({
    super.key,
    required this.isLoading,
    required this.child,
    this.loadingColor,
    this.isSafeArea = false,
  });

  final bool isLoading;
  final Widget child;
  final Color? loadingColor;
  final bool isSafeArea;

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isLoading,
      child: isSafeArea
          ? SafeArea(
              child: _buildBaseView(),
            )
          : _buildBaseView(),
    );
  }

  SizedBox _buildBaseView() {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          child,
          if (isLoading)
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 2.0,
                sigmaY: 2.0,
              ),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          if (isLoading)
            AppWidget.getLoadingIndicator(
              color: loadingColor ?? AppColor.primaryColor,
            ),
        ],
      ),
    );
  }
}
