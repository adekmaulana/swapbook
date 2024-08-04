import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:swapbook/infrastructure/services/api.service.dart';
import 'package:swapbook/infrastructure/services/firebase.service.dart';

import 'app.dart';
import 'data/repositories/local.repository.dart';
import 'infrastructure/navigation/routes.dart';
import 'infrastructure/services/location.service.dart';
import 'infrastructure/theme/app.widget.dart';

typedef AppBuilder = Future<Widget> Function(String initialRoute);

Future<void> bootstrap(AppBuilder builder) async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  await Get.putAsync(
    () async => await LocalRepository().init(),
    permanent: true,
  );
  Get.put<ApiService>(ApiService(), permanent: true);

  await Get.putAsync<LocationService>(
    () async => await LocationService.init(),
    permanent: true,
  );
  await dotenv.load(fileName: ".env");
  await FirebaseService.init();

  await OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize('fa5fe931-e95d-432d-81c2-623f4cdc99fc');

  await OneSignal.Notifications.requestPermission(false).then((status) async {
    if (status) {
      await OneSignal.consentGiven(true);
    } else {
      await AppWidget.getPermissionAwareDialog();
    }
  });

  runApp(await builder(await Routes.initialRoute));
}

Future<void> main() async {
  await bootstrap(
    (route) async {
      return Main(route);
    },
  );
}
