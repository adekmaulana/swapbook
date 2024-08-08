import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';

import '../../data/dto/google_book_search.response.dart';
import '../../infrastructure/theme/app.color.dart';
import '../../infrastructure/theme/app.widget.dart';
import '../widgets/text_field_search.widget.dart';
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
              leading: Row(
                children: [
                  const SizedBox(width: 24),
                  IconButton(
                    icon: SvgPicture.asset(
                      'assets/icons/back.svg',
                      colorFilter: const ColorFilter.mode(
                        AppColor.primaryBlackColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    padding: EdgeInsets.zero,
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
                ],
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
                      onLongPress: () async {
                        await controller.showImage();
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
                                borderRadius: BorderRadius.circular(
                                  25.54 + 1.5,
                                ),
                                child: Image.file(
                                  File(controller.selectedImage.value!),
                                  fit: BoxFit.cover,
                                ),
                              );
                            }

                            if (controller.selectedBook.value != null) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  25.54 + 1.5,
                                ),
                                child: Image.network(
                                  controller.selectedBook.value?.value
                                          ?.volumeInfo?.imageLinks?.thumbnail ??
                                      '',
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, o, event) {
                                    if (event == null) {
                                      return o;
                                    }

                                    return AppWidget.getLoadingIndicator(
                                      color: AppColor.primaryColor,
                                    );
                                  },
                                  errorBuilder: (context, o, error) {
                                    if (controller.selectedImage.value !=
                                        null) {
                                      return Image.file(
                                        File(controller.selectedImage.value!),
                                        fit: BoxFit.fill,
                                      );
                                    }

                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                        'Title Book',
                        style: TextStyle(
                          color: AppColor.primaryBlackColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8.34),
                      TextFieldSearch(
                        itemsInView: 6,
                        future: () {
                          return controller.searchBooks();
                        },
                        getSelectedValue: (Items item) {
                          controller.selectedBook.value = item;

                          controller.titleController.text =
                              item.value!.volumeInfo!.title!;
                          controller.authorController.text =
                              item.value!.volumeInfo!.authors!.join(', ');
                          controller.genreController.text =
                              item.value!.volumeInfo?.categories?.join(', ') ??
                                  '';
                          controller.synopsisController.text =
                              item.value!.volumeInfo?.description ?? '';

                          if (controller.synopsisController.text.isEmpty) {
                            controller.errorSynopsis.value =
                                'Please enter synopsis, some results does not provide synopsis.';
                          } else {
                            controller.errorSynopsis.value = null;
                          }

                          if (controller.genreController.text.isEmpty) {
                            controller.errorGenre.value =
                                'Please enter genre, some results does not provide.';
                          } else {
                            controller.errorGenre.value = null;
                          }
                        },
                        controller: controller.titleController,
                        label: 'Title Book',
                        cursorColor: AppColor.primaryColor,
                        textStyle: const TextStyle(
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
                        'Author Book',
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
                        readOnly: true,
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
                      Obx(
                        () => TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          readOnly: controller.selectedBook.value == null ||
                              controller.selectedBook.value != null &&
                                  controller.selectedBook.value!.value!
                                          .volumeInfo?.categories !=
                                      null,
                          controller: controller.genreController,
                          onChanged: (value) {
                            if (value.isEmpty) {
                              controller.errorGenre.value =
                                  'Please enter genre';
                            } else {
                              controller.errorGenre.value = null;
                            }
                          },
                          validator: (value) {
                            return controller.errorGenre.value;
                          },
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
                      Obx(
                        () => TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                          onChanged: (value) {
                            if (value.isEmpty) {
                              controller.errorSynopsis.value =
                                  'Please enter synopsis';
                            } else {
                              controller.errorSynopsis.value = null;
                            }
                          },
                          validator: (value) {
                            return controller.errorSynopsis.value;
                          },
                          readOnly: controller.selectedBook.value == null ||
                              controller.selectedBook.value != null &&
                                  controller.selectedBook.value?.value!
                                          .volumeInfo?.description !=
                                      null,
                          textAlignVertical: TextAlignVertical.top,
                          decoration: InputDecoration(
                            errorText: controller.errorSynopsis.value,
                            alignLabelWithHint: true,
                            hintText: 'Enter synopsis',
                            hintStyle: const TextStyle(
                              color: AppColor.borderColor,
                              fontSize: 11,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 14.35,
                            ),
                            filled: true,
                            fillColor: AppColor.backgroundColor,
                          ),
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
                          onPressed: () async {
                            if (controller.isLoading) {
                              return;
                            }

                            await controller.post();
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
