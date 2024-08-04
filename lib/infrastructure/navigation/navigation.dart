import 'package:get/get.dart';

import '../../presentation/screens.dart';
import 'bindings/controllers/controllers_bindings.dart';
import 'routes.dart';

class Nav {
  static List<GetPage> routes = [
    GetPage(
      name: Routes.HOME,
      page: () => const HomeScreen(),
      bindings: [
        HomeControllerBinding(),
        KatalogControllerBinding(),
        SearchControllerBinding(),
        BookmarksControllerBinding(),
        ChatControllerBinding(),
        ProfileControllerBinding(),
        ChatFindControllerBinding(),
      ],
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
    GetPage(
      name: Routes.KATALOG,
      page: () => const KatalogScreen(),
      binding: KatalogControllerBinding(),
    ),
    GetPage(
      name: Routes.SEARCH,
      page: () => const SearchScreen(),
      binding: SearchControllerBinding(),
    ),
    GetPage(
      name: Routes.BOOKMARKS,
      page: () => const BookmarksScreen(),
      binding: BookmarksControllerBinding(),
    ),
    GetPage(
      name: Routes.CHAT,
      page: () => const ChatScreen(),
      binding: ChatControllerBinding(),
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => const ProfileScreen(),
      binding: ProfileControllerBinding(),
    ),
    GetPage(
      name: Routes.CHAT_ROOM,
      page: () => const ChatroomScreen(),
      binding: ChatroomControllerBinding(),
    ),
    GetPage(
      name: Routes.EDIT_PROFILE,
      page: () => const EditProfileScreen(),
      binding: EditProfileControllerBinding(),
    ),
    GetPage(
      name: Routes.POST,
      page: () => const PostScreen(),
      binding: PostControllerBinding(),
    ),
  ];
}
