import 'package:swapbook/config.dart';

class LocalRepositoryKey {
  LocalRepositoryKey._();

  static const String TOKEN = 'token';
  static const String IS_LOGGED_IN = 'isLoggedIn';
  static const String USER = 'user';
  static const String FIREBASE_TOKEN = 'firebaseToken';
  static const String APNS_TOKEN = 'apnsToken';
}

class AppUrl {
  AppUrl._();

  // base url
  static String baseUrl = ConfigEnvironments.getEnvironments()['url'] ??
      'http://10.0.2.2:8000/api/v1';

  // receiveTimeout
  static const int receiveTimeout = 30000;

  // connectTimeout
  static const int connectionTimeout = 30000;

  static const String login = '/auth/login';
  static const String loginGoogle = '/auth/login-google';
  static const String logout = '/auth/logout';
  static const String register = '/auth/register';
  static const String forgotPassword = '/auth/forgot-password';
}
