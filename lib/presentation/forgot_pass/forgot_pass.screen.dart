import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../../infrastructure/theme/app.color.dart';
import '../../infrastructure/theme/app.widget.dart';
import 'controllers/forgot_pass.controller.dart';

class ForgotPassScreen extends GetView<ForgotPassController> {
  const ForgotPassScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.backgroundColor,
        image: DecorationImage(
          image: Image.asset(
            'assets/images/background-forgotpass.png',
            color: AppColor.backgroundColor.withOpacity(0.08),
            colorBlendMode: BlendMode.hardLight,
          ).image,
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0x40000000).withOpacity(0.08),
            blurRadius: 4.35,
            offset: const Offset(0, 4.35),
          ),
        ],
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          title: const Text(
            'Forgot Password',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColor.primaryBlackColor,
            ),
          ),
          centerTitle: true,
          toolbarHeight: 60,
          leading: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: SvgPicture.asset(
                'assets/icons/arrow_back.svg',
              ),
              onPressed: () => Get.back(),
            ),
          ),
        ),
        body: GetBuilder(
          init: controller,
          builder: (_) {
            return BaseView(
              isLoading: controller.isLoading,
              child: Container(
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 44,
                ),
                child: Column(
                  children: [
                    const Text(
                      'We will email you a link to reset your password.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColor.baseBlackColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Email',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColor.primaryBlackColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Form(
                          key: controller.emailKey,
                          child: TextFormField(
                            autovalidateMode: AutovalidateMode.always,
                            controller: controller.emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              hintText: 'Enter your email',
                              hintStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColor.secondaryGreyColor,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  color: AppColor.borderColor,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: AppColor.primaryColor,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  color: AppColor.borderColor,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'The email field is required.';
                              }

                              if (!value.isEmail) {
                                return 'Invalid email address';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: Get.mediaQuery.size.width,
                      height: 52,
                      child: MaterialButton(
                        onPressed: () async {
                          await controller.forgotPass();
                        },
                        color: AppColor.secondaryColor,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        enableFeedback: true,
                        highlightElevation: 2,
                        elevation: 0,
                        child: const Text(
                          'Send',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
