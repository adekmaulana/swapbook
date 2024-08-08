import 'package:swapbook/data/repositories/local.repository.dart';

import '../constant.dart';

class Routes {
  static Future<String> get initialRoute async {
    LocalRepository localRepository = await LocalRepository().init();
    String token = await localRepository.get<String>(
      LocalRepositoryKey.TOKEN,
      '',
    );
    bool isLoggedIn = await localRepository.get(
      LocalRepositoryKey.IS_LOGGED_IN,
      false,
    );

    if (token.isNotEmpty && isLoggedIn) {
      return HOME;
    }

    return WELCOME;
  }

  static const BOOKMARKS = '/bookmarks';
  static const CHAT = '/chat';
  static const CHAT_FIND = '/chat-find';
  static const CHAT_ROOM = '/chat-room';
  static const EDIT_PROFILE = '/edit-profile';
  static const FORGOT_PASS = '/forgot-pass';
  static const HOME = '/home';
  static const KATALOG = '/katalog';
  static const LOGIN = '/login';
  static const POST = '/post';
  static const PROFILE = '/profile';
  static const REGISTER = '/register';
  static const SEARCH = '/search';
  static const WELCOME = '/welcome';
  static const DETAIL_POST = '/detail-post';
}
