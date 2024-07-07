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

  static const HOME = '/home';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const WELCOME = '/welcome';
  static const FORGOT_PASS = '/forgot-pass';
}
