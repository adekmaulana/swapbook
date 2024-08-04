import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class OneSignalService extends GetxService {
  static const String _oneSignalAppId = 'fa5fe931-e95d-432d-81c2-623f4cdc99fc';

  String tagName = 'user_id';
  static void init() {
    OneSignal.Debug.setLogLevel(OSLogLevel.debug);
    OneSignal.Debug.setAlertLevel(OSLogLevel.debug);

    OneSignal.consentRequired(true);

    OneSignal.initialize(_oneSignalAppId);
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

  void sendUserTag(String userId) {
    OneSignal.User.addTagWithKey(tagName, userId);
  }

  void deleteUserTag() {
    OneSignal.User.removeTag(tagName);
  }
}
