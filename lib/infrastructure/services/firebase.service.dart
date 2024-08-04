import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

import '../../firebase_options.dart';

class FirebaseService extends GetxService {
  static final FirebaseAnalytics _firebaseAnalytics =
      FirebaseAnalytics.instance;
  static FirebaseAnalytics get firebaseAnalytics => _firebaseAnalytics;

  static Future<void> init() async {
    await Firebase.initializeApp(
      name: 'swapbook',
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
