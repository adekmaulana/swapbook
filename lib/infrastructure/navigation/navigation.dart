import 'package:get/get.dart';

import '../../presentation/screens.dart';
import 'bindings/controllers/controllers_bindings.dart';
import 'routes.dart';

class Nav {
  static List<GetPage> routes = [
    GetPage(
      name: Routes.HOME,
      page: () => const HomeScreen(),
      binding: HomeControllerBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginScreen(),
      binding: LoginControllerBinding(),
      children: [
        GetPage(
          name: Routes.FORGOT_PASS,
          page: () => const ForgotPassScreen(),
          binding: ForgotPassControllerBinding(),
        ),
      ],
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => const RegisterScreen(),
      binding: RegisterControllerBinding(),
    ),
    GetPage(
      name: Routes.WELCOME,
      page: () => const WelcomeScreen(),
      binding: WelcomeControllerBinding(),
    ),
  ];
}
