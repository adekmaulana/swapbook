import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';

import '../../infrastructure/theme/app.color.dart';
import '../../infrastructure/theme/app.widget.dart';
import 'controllers/post.controller.dart';

class PostScreen extends GetView<PostController> {
  const PostScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<PostController>(
      init: controller,
      builder: (controller) {
        return BaseView(
          isLoading: controller.isLoading,
          child: Scaffold(
            extendBody: true,
            backgroundColor: AppColor.backgroundColor,
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
                'Create New Post',
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
                  left: 25,
                ),
                constraints: const BoxConstraints(),
                style: const ButtonStyle(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                iconSize: 24,
                onPressed: () {
                  if (controller.isLoading) {
                    return;
                  }

                  Get.back();
                },
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25.54,
                    ),
                    height: 159.65,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(25.54 + 1.5),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        await controller.pickImage();
                      },
                      child: DottedBorder(
                        color: const Color(0xFF3D405B),
                        strokeWidth: 1.5,
                        stackFit: StackFit.expand,
                        dashPattern: const [2, 2],
                        customPath: (size) {
                          return Path()
                            ..addRRect(
                              RRect.fromLTRBR(
                                1.5,
                                1.5,
                                size.width - 1.5,
                                size.height - 1.5,
                                const Radius.circular(25.54 + 1.5),
                              ),
                            );
                        },
                        child: Obx(
                          () {
                            if (controller.selectedImage.value != null) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(25.54),
                                child: Image.file(
                                  File(controller.selectedImage.value!),
                                  fit: BoxFit.cover,
                                ),
                              );
                            }

                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/image.svg',
                                  width: 24,
                                  height: 24,
                                ),
                                const SizedBox(height: 12.77),
                                const Text(
                                  'Select image',
                                  style: TextStyle(
                                    color: Color(0xFF9E9E9E),
                                    fontSize: 12.77,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 27.35),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Title',
                        style: TextStyle(
                          color: AppColor.primaryBlackColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8.34),
                      TextFormField(
                        controller: controller.titleController,
                        style: const TextStyle(
                          color: AppColor.primaryBlackColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Enter title',
                          hintStyle: TextStyle(
                            color: AppColor.borderColor,
                            fontSize: 11,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14.35,
                          ),
                          filled: true,
                          fillColor: AppColor.backgroundColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24.00),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Author',
                        style: TextStyle(
                          color: AppColor.primaryBlackColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8.34),
                      TextFormField(
                        controller: controller.authorController,
                        style: const TextStyle(
                          color: AppColor.primaryBlackColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Enter author',
                          hintStyle: TextStyle(
                            color: AppColor.borderColor,
                            fontSize: 11,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14.35,
                          ),
                          filled: true,
                          fillColor: AppColor.backgroundColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24.00),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Genre',
                        style: TextStyle(
                          color: AppColor.primaryBlackColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8.34),
                      TextFormField(
                        controller: controller.genreController,
                        style: const TextStyle(
                          color: AppColor.primaryBlackColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Enter genre',
                          hintStyle: TextStyle(
                            color: AppColor.borderColor,
                            fontSize: 11,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14.35,
                          ),
                          filled: true,
                          fillColor: AppColor.backgroundColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24.00),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Synopsis',
                        style: TextStyle(
                          color: AppColor.primaryBlackColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8.34),
                      TextFormField(
                        controller: controller.synopsisController,
                        maxLines: null,
                        minLines: 4,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        keyboardType: TextInputType.multiline,
                        style: const TextStyle(
                          color: AppColor.primaryBlackColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlignVertical: TextAlignVertical.top,
                        decoration: const InputDecoration(
                          alignLabelWithHint: true,
                          hintText: 'Enter synopsis',
                          hintStyle: TextStyle(
                            color: AppColor.borderColor,
                            fontSize: 11,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14.35,
                          ),
                          filled: true,
                          fillColor: AppColor.backgroundColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // Material button cancel and posting
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
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 20,
                          ),
                          height: 51,
                          elevation: 0,
                          highlightElevation: 2,
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.54),
                          ),
                          color: AppColor.primaryColor,
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'SF Pro Display',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: MaterialButton(
                          onPressed: () {
                            if (controller.isLoading) {
                              return;
                            }

                            // controller.post();
                          },
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 20,
                          ),
                          height: 51,
                          elevation: 0,
                          highlightElevation: 2,
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.54),
                          ),
                          color: AppColor.secondaryColor,
                          child: const Text(
                            'Posting',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'SF Pro Display',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Get.mediaQuery.viewPadding.bottom),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
