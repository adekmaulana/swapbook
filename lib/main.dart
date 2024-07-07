import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:swapbook/infrastructure/services/api.service.dart';
import 'package:swapbook/infrastructure/services/firebase.service.dart';

import 'app.dart';
import 'data/repositories/local.repository.dart';
import 'infrastructure/navigation/routes.dart';

typedef AppBuilder = Future<Widget> Function(String initialRoute);

Future<void> bootstrap(AppBuilder builder) async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  await Get.putAsync(
    () async => await LocalRepository().init(),
    permanent: true,
  );

  Get.put(ApiService(), permanent: true);
  await FirebaseService.init();

  runApp(await builder(await Routes.initialRoute));
}

Future<void> main() async {
  await bootstrap(
    (route) async {
      // WidgetsBinding.instance.addPersistentFrameCallback(
      //   (_) {
      //     SystemChrome.setSystemUIOverlayStyle(
      //       SystemUiOverlayStyle.dark.copyWith(
      //         statusBarColor: Colors.transparent,
      //         statusBarIconBrightness: Brightness.light,
      //         statusBarBrightness: Brightness.dark,
      //         systemNavigationBarColor: AppColor.primaryColor,
      //         systemNavigationBarIconBrightness: Brightness.dark,
      //       ),
      //     );
      //   },
      // );

      return Main(route);
    },
  );
}
