import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/case/auth/login.case.dart';
import '../../../infrastructure/constant.dart';
import '../../../infrastructure/theme/app.widget.dart';
import '../../controller.dart.dart';

class LoginController extends BaseController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Rx<String?> emailError = Rx<String?>(null);
  Rx<String?> passwordError = Rx<String?>(null);
  RxBool isPasswordVisible = false.obs;

  @override
  void onInit() {
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

  Future<void> signIn() async {
    validateEmail(emailController.text);
    validatePassword(passwordController.text);

    if (emailError.value != null || passwordError.value != null) {
      return;
    }

    showLoading(true);
    try {
      final userResponse = await AuthLoginCase().call(
        emailController.text,
        passwordController.text,
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

      Get.offAllNamed('/home');
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

  void validateEmail(String value) {
    if (value.isNotEmpty) {
      if (!value.isEmail) {
        emailError.value = 'Invalid email address';
        return;
      }
      emailError.value = null;
    } else {
      emailError.value = 'The email field is required.';
    }
  }

  void validatePassword(String value) {
    if (value.isNotEmpty) {
      passwordError.value = null;
    } else {
      passwordError.value = 'The password field is required.';
    }
  }

  void loseFocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
