import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:like_button/like_button.dart';
import 'package:readmore/readmore.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../data/models/book.model.dart';
import '../../infrastructure/theme/app.color.dart';
import '../../infrastructure/theme/app.widget.dart';
import 'controllers/detail_post.controller.dart';

class DetailPostScreen extends GetView<DetailPostController> {
  const DetailPostScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: SvgPicture.asset('assets/icons/indicator.svg'),
        toolbarHeight: 30,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: controller.obx(
        onLoading: Center(
          child: AppWidget.getLoadingIndicator(
            color: AppColor.primaryColor,
          ),
        ),
        (state) {
          final book = state;
          return Container(
            margin: const EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 25,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        style: const ButtonStyle(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        iconSize: 24,
                        icon: SvgPicture.asset(
                          'assets/icons/back.svg',
                        ),
                      ),
                      const SizedBox(width: 20),
                      const Text(
                        'Detail Book',
                        style: TextStyle(
                          color: AppColor.baseBlackColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox(
                    height: 250,
                    width: 200,
                    child: CachedNetworkImage(
                      imageUrl: book?.image ?? book?.imageLink ?? '',
                      fit: BoxFit.fill,
                      placeholder: (context, url) {
                        return AppWidget.getLoadingIndicator(
                          color: AppColor.primaryColor,
                        );
                      },
                      errorWidget: (context, url, error) {
                        return Center(
                          child: Icon(
                            Icons.error_rounded,
                            color: AppColor.errorColor,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 36,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/calendar.svg',
                            width: 18,
                            height: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            DateFormat('dd MMMM yyyy').format(
                              book?.createdAt ?? DateTime.now(),
                            ),
                            style: TextStyle(
                              color: AppColor.primaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/location.svg',
                            width: 18,
                            height: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            controller.location.isNotEmpty
                                ? '${controller.location['subAdministrativeArea'] ?? ''}, ${controller.location['administrativeArea'] ?? ''}'
                                : 'No Location.',
                            style: TextStyle(
                              color: AppColor.primaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: Get.width - 96,
                            child: Text(
                              book?.title ?? '',
                              style: const TextStyle(
                                color: AppColor.baseBlackColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                height: 1.25,
                              ),
                              maxLines: 3,
                            ),
                          ),
                          Visibility(
                            visible: book?.user?.id !=
                                controller.homeController.user.value.id,
                            child: LikeButton(
                              size: 24,
                              likeBuilder: (bool isLiked) {
                                if (isLiked) {
                                  return const Icon(
                                    Icons.favorite_rounded,
                                    color: Color(0xFFFF8686),
                                    size: 24,
                                  );
                                }

                                return Icon(
                                  Icons.favorite_outline_rounded,
                                  color: AppColor.primaryColor,
                                  size: 24,
                                );
                              },
                              isLiked: controller.isBookmarked.value,
                              onTap: (isLiked) async {
                                return await controller.bookmark();
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12.48),
                      Text(
                        'by ${book!.author!.first}',
                        style: TextStyle(
                          color: AppColor.secondaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12.48),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              ReadMoreText(
                                book.synopsis!,
                                trimMode: TrimMode.Line,
                                trimLines: 2,
                                trimCollapsedText: ' read more',
                                trimExpandedText: ' read less',
                                style: const TextStyle(
                                  color: AppColor.borderColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Rating
                SizedBox(
                  height: 30,
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Rating',
                          style: TextStyle(
                            color: AppColor.baseBlackColor,
                            fontSize: 14.56,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            ShaderMask(
                              blendMode: BlendMode.srcATop,
                              shaderCallback: (Rect rect) {
                                return LinearGradient(
                                  stops: [
                                    0,
                                    book.averageRating != null
                                        ? book.averageRating! / 5
                                        : 0,
                                    book.averageRating != null
                                        ? book.averageRating! / 5
                                        : 0,
                                  ],
                                  colors: [
                                    AppColor.secondaryColor,
                                    AppColor.secondaryColor,
                                    AppColor.secondaryColor.withOpacity(0),
                                  ],
                                ).createShader(rect);
                              },
                              child: Row(
                                children: List.generate(
                                  5,
                                  (index) => SizedBox(
                                    width: 25,
                                    height: 25,
                                    child: SvgPicture.asset(
                                      'assets/icons/star.svg',
                                      width: 25,
                                      height: 25,
                                      colorFilter: const ColorFilter.mode(
                                        Color(0xFFC8C8C8),
                                        BlendMode.srcATop,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  '(${book.averageRating ?? 0})',
                                  style: const TextStyle(
                                    color: Color(0xFF121212),
                                    fontSize: 14.56,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'SF Pro Display',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Button Message and Button Request Swap MaterialButton
                if (book.user!.id != controller.homeController.user.value.id)
                  SizedBox(
                    height: 51,
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildButton(
                            () async {
                              await controller.goToChat(book.user!.id!);
                            },
                            title: 'Message',
                            color: AppColor.primaryColor,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildButton(
                            () async {
                              await controller.requestSwap(
                                book.id!,
                                book.user!.id!,
                              );
                            },
                            title: 'Request Swap',
                            color: AppColor.secondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (book.status == BookStatus.finished)
                  SizedBox(
                    height: 51,
                    width: MediaQuery.of(context).size.width,
                    child: _buildButton(
                      () {},
                      title: 'Repost',
                      color: AppColor.secondaryColor,
                    ),
                  ),
                SizedBox(height: MediaQuery.of(context).viewPadding.bottom),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildButton(
    void Function()? onPress, {
    required String title,
    required Color color,
  }) {
    return MaterialButton(
      onPressed: onPress,
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      height: 51,
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 20,
      ),
      elevation: 0,
      highlightElevation: 2,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          fontFamily: 'SF Pro Display',
        ),
      ),
    );
  }
}
