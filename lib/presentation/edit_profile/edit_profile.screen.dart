import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart' hide Svg;

import 'package:get/get.dart';

import '../../infrastructure/theme/app.color.dart';
import '../../infrastructure/theme/app.widget.dart';
import 'controllers/edit_profile.controller.dart';

class EditProfileScreen extends GetView<EditProfileController> {
  const EditProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: controller,
      builder: (controller) {
        return BaseView(
          isLoading: controller.isLoading,
          child: Scaffold(
            backgroundColor: AppColor.backgroundColor,
            extendBody: true,
            appBar: AppBar(
              scrolledUnderElevation: 0,
              backgroundColor: Colors.transparent,
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.dark,
                statusBarBrightness: Brightness.light,
                systemNavigationBarColor: AppColor.backgroundColor,
                systemNavigationBarIconBrightness: Brightness.dark,
              ),
              titleSpacing: 20,
              title: const Text(
                'Edit Profile',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColor.primaryBlackColor,
                ),
              ),
              centerTitle: false,
              leading: IconButton(
                icon: SvgPicture.asset(
                  'assets/icons/back.svg',
                  colorFilter: const ColorFilter.mode(
                    AppColor.primaryBlackColor,
                    BlendMode.srcIn,
                  ),
                ),
                padding: const EdgeInsets.only(
                  left: 24,
                ),
                constraints: const BoxConstraints(),
                style: const ButtonStyle(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                iconSize: 24,
                onPressed: () {
                  Get.back();
                },
              ),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                bottom: MediaQuery.of(context).viewPadding.bottom,
              ),
              child: Column(
                children: [
                  Center(
                    child: SizedBox(
                      height: 121,
                      width: 121,
                      child: InkWell(
                        onTap: () {
                          controller.pickImage();
                        },
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(60.5),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(60.5),
                          child: Obx(
                            () {
                              String image = 'assets/images/avatar-man.png';
                              if (controller.selectedImage.value != null) {
                                image = controller.selectedImage.value!;
                              }
                              return CircleAvatar(
                                backgroundColor: const Color(0xFFB4D1C4),
                                child: CachedNetworkImage(
                                  imageUrl: controller
                                          .homeController.user.value.photoURL ??
                                      '',
                                  placeholder: (context, url) =>
                                      AppWidget.getLoadingIndicator(
                                    color: AppColor.primaryColor,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                    image,
                                    fit: BoxFit.cover,
                                    scale: 4,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  buildTextField(
                    textController: controller.nameController,
                    label: 'Full Name',
                    hint: 'Enter your name',
                    errorText: controller.nameError,
                  ),
                  const SizedBox(height: 15.95),
                  buildTextField(
                    textController: controller.usernameController,
                    label: 'Username',
                    hint: 'Enter your username',
                    errorText: controller.usernameError,
                  ),
                  const SizedBox(height: 15.95),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Gender',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColor.primaryBlackColor,
                        ),
                      ),
                      const SizedBox(height: 8.34),
                      Theme(
                        data: Theme.of(context).copyWith(
                          canvasColor: AppColor.backgroundColor,
                        ),
                        child: DropdownButtonFormField<int>(
                          value: controller.selectedGender.value,
                          items: controller.genderList.entries
                              .map(
                                (e) => DropdownMenuItem<int>(
                                  value: e.key,
                                  child: Text(e.value),
                                ),
                              )
                              .toList(),
                          onChanged: (int? value) {
                            controller.selectedGender.value = value;
                          },
                          isExpanded: true,
                          hint: const Text(
                            'Select gender',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: AppColor.borderColor,
                            ),
                          ),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                width: 0.83,
                                color: AppColor.borderColor,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                width: 0.83,
                                color: AppColor.borderColor,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                width: 0.83,
                                color: AppColor.primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15.95),
                  Row(
                    children: [
                      Expanded(
                        child: buildTextField(
                          textController: controller.instagramController,
                          label: 'Instagram',
                          hint: 'Instagram username',
                          errorText: controller.instagramError,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: buildTextField(
                          textController: controller.twitterController,
                          label: 'Twitter',
                          hint: 'Twitter username',
                          errorText: controller.twitterError,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15.95),
                  buildTextField(
                    textController: controller.currentPasswordController,
                    label: 'Current Password',
                    hint: 'Enter your current password',
                    isPassword: true,
                    errorText: controller.currentPasswordError,
                  ),
                  const SizedBox(height: 15.95),
                  buildTextField(
                    textController: controller.passwordController,
                    label: 'New Password',
                    hint: 'Enter your new password',
                    isPassword: true,
                    errorText: controller.passwordError,
                  ),
                  const SizedBox(height: 15.95),
                  buildTextField(
                    textController: controller.confirmPasswordController,
                    label: 'Confirm Password',
                    hint: 'Confirm your new password',
                    isPassword: true,
                    errorText: controller.confirmPasswordError,
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: MaterialButton(
                          onPressed: () {
                            if (controller.isLoading) {
                              return;
                            }

                            Get.back();
                          },
                          height: 51,
                          minWidth: Get.width / 2 - 16,
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          elevation: 0,
                          highlightElevation: 2,
                          color: AppColor.primaryColor,
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'SF Pro Display',
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 22),
                      Expanded(
                        child: MaterialButton(
                          onPressed: () {
                            controller.saveProfile();
                          },
                          height: 51,
                          minWidth: Get.width / 2 - 16,
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          elevation: 0,
                          highlightElevation: 2,
                          color: AppColor.secondaryColor,
                          child: const Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'SF Pro Display',
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildTextField({
    required TextEditingController textController,
    required String label,
    required String hint,
    required Rx<String?> errorText,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColor.primaryBlackColor,
          ),
        ),
        const SizedBox(height: 8.34),
        Obx(
          () => TextField(
            controller: textController,
            obscureText: isPassword,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              errorText: errorText.value,
              errorStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColor.errorColor,
              ),
              alignLabelWithHint: true,
              hintText: hint,
              hintStyle: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: AppColor.borderColor,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  width: 0.83,
                  color: AppColor.borderColor,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  width: 0.83,
                  color: AppColor.borderColor,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  width: 0.83,
                  color: AppColor.primaryColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
