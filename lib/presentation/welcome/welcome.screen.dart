import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../../infrastructure/navigation/routes.dart';
import '../../infrastructure/theme/app.color.dart';
import '../../infrastructure/theme/app.widget.dart';
import 'controllers/welcome.controller.dart';

class WelcomeScreen extends GetView<WelcomeController> {
  const WelcomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: AppColor.primaryColor,
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
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned(
                    bottom: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0x203D6E99),
                            Color(0xFF3D6E99),
                          ],
                        ),
                      ),
                      foregroundDecoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFF3D6E99),
                            Color(0x803D6E99),
                          ],
                        ),
                      ),
                      child: Image.asset(
                        'assets/images/background-welcome.png',
                        fit: BoxFit.cover,
                        width: Get.mediaQuery.size.width,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0x203D6E99),
                            Color(0xFF3D6E99),
                          ],
                        ),
                      ),
                      foregroundDecoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0x203D6E99),
                            Color(0xFF3D6E99),
                          ],
                        ),
                      ),
                      child: Image.asset(
                        'assets/images/welcome-logo.png',
                        fit: BoxFit.cover,
                        width: Get.mediaQuery.size.width,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                          left: 29,
                          right: 29,
                        ),
                        child: const Text(
                          'Read, Share, and Connect with Book Lovers',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.only(
                          left: 55,
                          right: 55,
                        ),
                        child: const Text(
                          'Join the community of book lovers and discover the best books from your favorite authors.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: Get.mediaQuery.padding.bottom,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 36,
                        right: 36,
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            width: Get.mediaQuery.size.width,
                            height: 52,
                            child: MaterialButton(
                              onPressed: () {
                                Get.toNamed(Routes.REGISTER);
                              },
                              color: AppColor.secondaryColor,
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              enableFeedback: true,
                              highlightElevation: 2,
                              elevation: 0,
                              child: const Text(
                                'Sign Up free',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: Get.mediaQuery.size.width,
                            height: 52,
                            child: MaterialButton(
                              onPressed: () async {
                                await controller.loginGoogle();
                              },
                              color: Colors.transparent,
                              splashColor: AppColor.primaryColor,
                              highlightColor: AppColor.primaryColor,
                              enableFeedback: true,
                              highlightElevation: 0,
                              elevation: 0,
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/google.svg',
                                    width: 24,
                                    height: 24,
                                  ),
                                  const Spacer(),
                                  const Text(
                                    'Continue with Google',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 51),
                          // have an account
                          Column(
                            children: [
                              const Text(
                                'have an account?',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed(Routes.LOGIN);
                                },
                                child: Text(
                                  'Sign in',
                                  style: TextStyle(
                                    color: AppColor.secondaryColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 51),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
