import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/case/auth/forgot_pass.case.dart';
import '../../../infrastructure/theme/app.widget.dart';
import '../../controller.dart.dart';

class ForgotPassController extends BaseController {
  TextEditingController emailController = TextEditingController();
  GlobalKey<FormState> emailKey = GlobalKey<FormState>();

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

  Future<void> forgotPass() async {
    if (!emailKey.currentState!.validate()) {
      return;
    }

    showLoading(true);
    try {
      final _ = await AuthForgotPassCase().call(
        emailController.text,
      );

      Get.back();
      AppWidget.openSnackbar(
        'Success!',
        'Please check your email to reset your password.',
        type: SnackBarStatus.success,
      );
    } catch (e) {
      String message = 'An error occurred on our end while sending.';
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
