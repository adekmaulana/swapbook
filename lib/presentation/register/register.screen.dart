import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../../infrastructure/theme/app.color.dart';
import '../../infrastructure/theme/app.widget.dart';
import 'controllers/register.controller.dart';

class RegisterScreen extends GetView<RegisterController> {
  const RegisterScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      extendBody: true,
      body: GetBuilder(
          init: controller,
          builder: (_) {
            return BaseView(
              isLoading: controller.isLoading,
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: LayoutBuilder(
                  builder: (
                    context,
                    constraints,
                  ) {
                    double width = Get.mediaQuery.size.width;
                    double height = Get.mediaQuery.size.height;
                    if (context.isLandscape) {
                      width = Get.mediaQuery.size.height;
                      height = Get.mediaQuery.size.width;
                    }
                    return Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: height / 2,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: Image.asset('assets/images/login.png')
                                      .image,
                                  scale: 4,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              child: Container(
                                height: 30,
                                decoration: BoxDecoration(
                                  color: AppColor.primaryColor,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30),
                                  ),
                                ),
                                constraints: BoxConstraints(
                                  minWidth: width,
                                  maxWidth: Get.width,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Stack(
                          children: [
                            Positioned(
                              bottom: 0,
                              child: Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0xF23D6E99),
                                      Color(0x203D6E99),
                                    ],
                                  ),
                                ),
                                foregroundDecoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0xF23D6E99),
                                      Color(0x203D6E99),
                                    ],
                                  ),
                                ),
                                child: Image.asset(
                                  'assets/images/background-login.png',
                                  width: width,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                children: [
                                  buildTextField(
                                    'Full Name',
                                    controller.nameError,
                                    controller.nameController,
                                    controller.validateName,
                                    TextInputType.name,
                                  ),
                                  const SizedBox(height: 16),
                                  buildTextField(
                                    'Email Address',
                                    controller.emailError,
                                    controller.emailController,
                                    controller.validateEmail,
                                    TextInputType.emailAddress,
                                  ),
                                  const SizedBox(height: 16),
                                  buildTextField(
                                    'Password',
                                    controller.passwordError,
                                    controller.passwordController,
                                    controller.validatePassword,
                                    TextInputType.visiblePassword,
                                  ),
                                  const SizedBox(height: 16),
                                  buildTextField(
                                    'Confirm Password',
                                    controller.confirmPasswordError,
                                    controller.confirmPasswordController,
                                    controller.validateConfirmPassword,
                                    TextInputType.visiblePassword,
                                  ),
                                  const SizedBox(height: 40),
                                  SizedBox(
                                    width: Get.mediaQuery.size.width,
                                    height: 52,
                                    child: MaterialButton(
                                      onPressed: () async {
                                        await controller.register();
                                      },
                                      color: AppColor.secondaryColor,
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      enableFeedback: true,
                                      highlightElevation: 2,
                                      elevation: 0,
                                      child: const Text(
                                        'Create Account',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'You have an account? ',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () {
                                          if (Get.previousRoute == '/login') {
                                            Get.back();
                                          } else {
                                            Get.offNamed('/login');
                                          }
                                        },
                                        child: Text(
                                          'Sign In',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            color: AppColor.secondaryColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            );
          }),
    );
  }

  Widget buildTextField(
    String fieldName,
    Rx<String?> errorText,
    TextEditingController textController,
    void Function(String) validateField,
    TextInputType textInputType,
  ) {
    return Column(
      children: [
        Obx(
          () => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xCC313E55),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: errorText.value == null
                    ? Colors.transparent
                    : AppColor.errorColor,
              ),
            ),
            padding: EdgeInsets.only(
              top: 12,
              bottom: 12,
              left: 14,
              right: fieldName == 'Password' ? 0 : 14,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          fieldName,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0x80FFFFFF),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          onChanged: (value) {
                            validateField(value);
                          },
                          onTapOutside: (event) {
                            validateField(textController.text);
                            controller.loseFocus();
                          },
                          controller: textController,
                          keyboardType: textInputType,
                          cursorColor: Colors.white,
                          obscureText: fieldName.contains('Password')
                              ? !controller.isPasswordVisible.value
                              : false,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (fieldName == 'Password')
                  IconButton(
                    onPressed: () {
                      controller.isPasswordVisible.toggle();
                    },
                    icon: Obx(
                      () {
                        return AnimatedCrossFade(
                          duration: const Duration(milliseconds: 300),
                          firstChild: SvgPicture.asset(
                            'assets/icons/eye.svg',
                          ),
                          firstCurve: Curves.easeInOut,
                          secondChild: SvgPicture.asset(
                            'assets/icons/eye-close.svg',
                          ),
                          secondCurve: Curves.easeInOut,
                          crossFadeState: controller.isPasswordVisible.value
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
        Obx(
          () {
            return AnimatedContainer(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(
                top: 4,
                left: 14,
              ),
              duration: const Duration(
                milliseconds: 300,
              ),
              height: errorText.value == null ? 0 : 24,
              child: Text(
                errorText.value ?? '',
                style: TextStyle(
                  color: AppColor.errorColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
