import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../../infrastructure/navigation/routes.dart';
import '../../infrastructure/theme/app.color.dart';
import '../../infrastructure/theme/app.widget.dart';
import 'controllers/login.controller.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        automaticallyImplyLeading: false,
      ),
      body: GetBuilder(
          init: controller,
          builder: (_) {
            return BaseView(
              isLoading: controller.isLoading,
              loadingColor: AppColor.secondaryColor,
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
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: width,
                              height: height * 0.5,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: Image.asset(
                                    'assets/images/login.png',
                                  ).image,
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
                        SizedBox(
                          height: height * 0.5,
                          child: Stack(
                            children: [
                              Positioned.fill(
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
                                    Column(
                                      children: [
                                        Obx(
                                          () => AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 300),
                                            height: 64,
                                            decoration: BoxDecoration(
                                              color: const Color(0xCC313E55),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: controller
                                                            .emailError.value ==
                                                        null
                                                    ? Colors.transparent
                                                    : AppColor.errorColor,
                                              ),
                                            ),
                                            padding: const EdgeInsets.only(
                                              top: 12,
                                              bottom: 12,
                                              left: 14,
                                              right: 14,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Expanded(
                                                  child: Text(
                                                    'Email Address',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Color(0x80FFFFFF),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: TextField(
                                                    onChanged: (value) {
                                                      controller
                                                          .validateEmail(value);
                                                    },
                                                    onTapOutside: (event) {
                                                      controller.validateEmail(
                                                        controller
                                                            .emailController
                                                            .text,
                                                      );
                                                      controller.loseFocus();
                                                    },
                                                    controller: controller
                                                        .emailController,
                                                    keyboardType: TextInputType
                                                        .emailAddress,
                                                    cursorColor: Colors.white,
                                                    decoration:
                                                        const InputDecoration(
                                                      border: InputBorder.none,
                                                      enabledBorder:
                                                          InputBorder.none,
                                                      disabledBorder:
                                                          InputBorder.none,
                                                      focusedBorder:
                                                          InputBorder.none,
                                                      isDense: true,
                                                      contentPadding:
                                                          EdgeInsets.zero,
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
                                        ),

                                        // Error message
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
                                              height:
                                                  controller.emailError.value ==
                                                          null
                                                      ? 0
                                                      : 24,
                                              child: Text(
                                                controller.emailError.value ??
                                                    '',
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
                                    ),
                                    const SizedBox(height: 16),
                                    Column(
                                      children: [
                                        Obx(
                                          () => AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 300),
                                            height: 64,
                                            decoration: BoxDecoration(
                                              color: const Color(0xCC313E55),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: controller.passwordError
                                                            .value ==
                                                        null
                                                    ? Colors.transparent
                                                    : AppColor.errorColor,
                                              ),
                                            ),
                                            padding: const EdgeInsets.only(
                                              top: 12,
                                              bottom: 12,
                                              left: 14,
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Expanded(
                                                        child: Text(
                                                          'Password',
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: Color(
                                                                0x80FFFFFF),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Obx(
                                                          () => TextField(
                                                            onChanged: (value) {
                                                              controller
                                                                  .validatePassword(
                                                                value,
                                                              );
                                                            },
                                                            onTapOutside:
                                                                (event) {
                                                              controller
                                                                  .validatePassword(
                                                                controller
                                                                    .passwordController
                                                                    .text,
                                                              );
                                                              controller
                                                                  .loseFocus();
                                                            },
                                                            controller: controller
                                                                .passwordController,
                                                            keyboardType:
                                                                TextInputType
                                                                    .visiblePassword,
                                                            obscureText: !controller
                                                                .isPasswordVisible
                                                                .value,
                                                            cursorColor:
                                                                Colors.white,
                                                            decoration:
                                                                const InputDecoration(
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              enabledBorder:
                                                                  InputBorder
                                                                      .none,
                                                              disabledBorder:
                                                                  InputBorder
                                                                      .none,
                                                              focusedBorder:
                                                                  InputBorder
                                                                      .none,
                                                              isDense: true,
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .zero,
                                                            ),
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 13,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    controller.isPasswordVisible
                                                        .toggle();
                                                  },
                                                  icon: Obx(
                                                    () {
                                                      return AnimatedCrossFade(
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    300),
                                                        firstChild:
                                                            SvgPicture.asset(
                                                          'assets/icons/eye.svg',
                                                        ),
                                                        firstCurve:
                                                            Curves.easeInOut,
                                                        secondChild:
                                                            SvgPicture.asset(
                                                          'assets/icons/eye-close.svg',
                                                        ),
                                                        secondCurve:
                                                            Curves.easeInOut,
                                                        crossFadeState: controller
                                                                .isPasswordVisible
                                                                .value
                                                            ? CrossFadeState
                                                                .showFirst
                                                            : CrossFadeState
                                                                .showSecond,
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        // Error message
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
                                              height: controller.passwordError
                                                          .value ==
                                                      null
                                                  ? 0
                                                  : 24,
                                              child: Text(
                                                controller
                                                        .passwordError.value ??
                                                    '',
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
                                    ),
                                    const SizedBox(height: 16),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: InkWell(
                                        onTap: () {
                                          Get.toNamed(Routes.FORGOT_PASS);
                                        },
                                        child: const Text(
                                          'Forgot your password?',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    SizedBox(
                                      width: Get.mediaQuery.size.width,
                                      height: 52,
                                      child: MaterialButton(
                                        onPressed: () async {
                                          await controller.signIn();
                                        },
                                        color: AppColor.secondaryColor,
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        enableFeedback: true,
                                        highlightElevation: 2,
                                        elevation: 0,
                                        child: const Text(
                                          'Sign In',
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'Don\'t have an account? ',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Get.toNamed(Routes.REGISTER);
                                          },
                                          child: Text(
                                            'Sign Up',
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
}
