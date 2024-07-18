import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'app.color.dart';

class AppWidget {
  AppWidget._();

  static final Map<String, Color> _color = {
    'error': AppColor.errorColor,
    'success': AppColor.successColor,
    'warning': AppColor.warningColor,
  };

  static final Map<String, Color> _textColor = {
    'error': AppColor.baseWhiteColor,
    'success': AppColor.baseBlackColor,
    'warning': AppColor.baseBlackColor,
  };

  static SnackbarController openSnackbar(
    String title,
    String message, {
    String type = 'error',
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
    double sizeAndroid = 12.0,
  }) {
    return SizedBox(
      child: Platform.isIOS
          ? CupertinoActivityIndicator(
              color: color ?? AppColor.secondaryColor,
              radius: sizeIOS,
            )
          : SizedBox(
              height: sizeAndroid,
              width: sizeAndroid,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  color ?? AppColor.secondaryColor,
                ),
                strokeWidth: 2.0,
              ),
            ),
    );
  }

  static Future<void> showNotification(
    int notificationId,
    String notificationTitle,
    String notificationContent,
    String payload, {
    String channelId = 'high_importance_channel',
    String channelTitle = 'Main Leads Notifications',
    String channelDescription = 'Default push notifications.',
    Priority notificationPriority = Priority.high,
    Importance notificationImportance = Importance.max,
  }) async {
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channelId,
      channelTitle,
      channelDescription: channelDescription,
      playSound: true,
      importance: notificationImportance,
      priority: notificationPriority,
      icon: 'launcher_notification',
      ticker: 'ticker',
    );
    const iOSPlatformChannelSpecifics = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      presentBanner: true,
      sound: '',
    );
    final platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    await FlutterLocalNotificationsPlugin().show(
      notificationId,
      notificationTitle,
      notificationContent,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  static Future<T?> showBottomSheet<T>({
    String? routeName,
    dynamic arguments,
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
      Container(
        height: Get.height - Get.mediaQuery.viewPadding.top,
        decoration: BoxDecoration(
          color: AppColor.backgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
          image: DecorationImage(
            image: Image.asset(
              'assets/images/background-bottomsheet.png',
              scale: 4,
            ).image,
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              AppColor.backgroundColor.withOpacity(0.08),
              BlendMode.hardLight,
            ),
          ),
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
}

class BaseView extends StatelessWidget {
  const BaseView({
    super.key,
    required this.isLoading,
    required this.child,
  });

  final bool isLoading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isLoading,
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          fit: StackFit.expand,
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
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: AppWidget.getLoadingIndicator(
                  color: AppColor.secondaryColor,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
