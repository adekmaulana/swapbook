import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:swapbook/presentation/controller.dart.dart';

import '../../../data/dto/user.response.dart';
import '../../../domain/case/auth/csrf_cookie.case.dart';
import '../../../domain/case/auth/login_google.case.dart';
import '../../../infrastructure/constant.dart';
import '../../../infrastructure/navigation/routes.dart';
import '../../../infrastructure/theme/app.widget.dart';

class WelcomeController extends BaseController {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'openid',
      'email',
      'profile',
      'https://www.googleapis.com/auth/books',
    ],
  );

  Cookie? csrfCookie;

  @override
  void onInit() async {
    showLoading(true);
    try {
      final response = await AuthCSRFCookieCase().call();
      if (response.statusCode == HttpStatus.noContent) {
        response.headers.forEach(
          (name, values) {
            if (name == HttpHeaders.setCookieHeader) {
              for (String value in values) {
                String key = value.substring(0, value.indexOf('=')).trim();

                if (key == 'XSRF-TOKEN') {
                  csrfCookie = Cookie.fromSetCookieValue(value);
                }
              }
            }
          },
        );
      }
    } finally {
      showLoading(false);
    }
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> loginGoogle() async {
    try {
      showLoading(true);

      GoogleSignInAccount? googleAccount = await _googleSignIn.signIn();
      if (googleAccount == null) {
        showLoading(false);

        AppWidget.openSnackbar(
          'Oops! Something went wrong.',
          'An error occurred while logging in with Google.',
        );
        return;
      }

      final UserResponse userResponse = await AuthLoginGoogleCase().call(
        csrfCookie,
        googleAccount.displayName ?? '',
        googleAccount.email,
        googleAccount.id,
      );

      await localRepository.put(
        LocalRepositoryKey.USER,
        jsonEncode(userResponse.user?.toJson() ?? {}),
      );
      await localRepository.put(
        LocalRepositoryKey.TOKEN,
        userResponse.token ?? '',
      );
      await localRepository.put(
        LocalRepositoryKey.IS_LOGGED_IN,
        true,
      );

      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      String message = 'An error occurred on our end while logging.';
      if (e is DioException) {
        message = e.response?.data['meta']['messages'] != null &&
                e.response?.data['meta']['messages'].isNotEmpty
            ? e.response?.data['meta']['messages'].first
            : e.response?.data['meta']['validations'] != null &&
                    e.response?.data['meta']['validations'].isNotEmpty
                ? e.response?.data['meta']['validations'].values.first.first
                : message;
      }

      AppWidget.openSnackbar(
        'Oops! Something went wrong.',
        message,
      );
    } finally {
      showLoading(false);
    }
  }
}
