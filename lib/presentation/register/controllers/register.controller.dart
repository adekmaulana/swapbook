import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/case/auth/register.case.dart';
import '../../../infrastructure/theme/app.widget.dart';
import '../../controller.dart.dart';

class RegisterController extends BaseController {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  Rx<String?> nameError = Rx<String?>(null);
  Rx<String?> emailError = Rx<String?>(null);
  Rx<String?> passwordError = Rx<String?>(null);
  Rx<String?> confirmPasswordError = Rx<String?>(null);
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

  Future<void> register() async {
    validateName(nameController.text);
    validateEmail(emailController.text);
    validatePassword(passwordController.text);
    validateConfirmPassword(confirmPasswordController.text);

    if (nameError.value != null ||
        emailError.value != null ||
        passwordError.value != null ||
        confirmPasswordError.value != null) {
      return;
    }

    showLoading(true);
    try {
      await AuthRegisterCase().call(
        nameController.text,
        emailController.text,
        passwordController.text,
        confirmPasswordController.text,
      );

      Get.back();
      AppWidget.openSnackbar(
        'Success',
        'User registered successfully. Please login to continue.',
        type: SnackBarStatus.success,
      );
    } catch (e) {
      String message = 'An error occurred on our end while registering user.';
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

  void validateName(String value) {
    if (value.isNotEmpty) {
      nameError.value = null;
    } else {
      nameError.value = 'The name field is required.';
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
      // check password confirmation
      if (confirmPasswordController.text.isNotEmpty) {
        validateConfirmPassword(confirmPasswordController.text);
      }
      passwordError.value = null;
    } else {
      passwordError.value = 'The password field is required.';
    }
  }

  void validateConfirmPassword(String value) {
    if (value.isNotEmpty) {
      if (value != passwordController.text) {
        confirmPasswordError.value = 'Password does not match';
        return;
      }
      confirmPasswordError.value = null;
    } else {
      confirmPasswordError.value = 'The confirm password field is required.';
    }
  }

  void loseFocus() {
    return;
  }
}
