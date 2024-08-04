import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_detection/keyboard_detection.dart';

import '../../data/models/message.model.dart';
import '../../infrastructure/constant.dart';
import '../../infrastructure/theme/app.color.dart';
import '../../infrastructure/theme/app.widget.dart';
import 'controllers/chatroom.controller.dart';

class ChatroomScreen extends GetView<ChatroomController> {
  const ChatroomScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return KeyboardDetection(
      controller: KeyboardDetectionController(
        onChanged: controller.onKeyboardState,
      ),
      child: Scaffold(
        extendBody: true,
        backgroundColor: AppColor.backgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          title: Row(
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
                  'assets/icons/back-chat.svg',
                ),
              ),
              const SizedBox(width: 13),
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFE9E9E9),
                  ),
                  child: Obx(
                    () => CachedNetworkImage(
                      imageUrl: controller.user.value.photoURL ?? '',
                      fit: BoxFit.scaleDown,
                      placeholder: (context, url) =>
                          AppWidget.getLoadingIndicator(
                        color: AppColor.secondaryColor,
                      ),
                      errorWidget: (context, url, error) {
                        return Center(
                          child: Obx(
                            () => Text(
                              controller.user.value.name
                                      ?.split(' ')
                                      .map(
                                        (word) => word[0],
                                      )
                                      .join('') ??
                                  '',
                              style: const TextStyle(
                                color: Color(0xFF292929),
                                fontSize: 16.27,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'SF Pro Display',
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                fit: FlexFit.tight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => Text(
                        controller.user.value.name ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Obx(
                      () {
                        if (controller.user.value.lastActive != null &&
                            controller.user.value.lastActive!.isAfter(
                              DateTime.now().subtract(5.minutes),
                            )) {
                          return const Text(
                            'Online',
                            style: TextStyle(
                              color: Color(0xFF65CF53),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'SF Pro Display',
                            ),
                          );
                        }

                        return Obx(
                          () => Text(
                            controller.user.value.lastActive != null
                                ? controller.user.value.lastActive!.isBefore(
                                    DateTime.now().toLocal(),
                                  )
                                    ? 'Last seen ${DateFormat.MMMd().format(controller.user.value.lastActive!.toLocal())} ${DateFormat.jm().format(controller.user.value.lastActive!.toLocal()).toLowerCase()}'
                                    : 'Last seen ${DateFormat.jm().format(controller.user.value.lastActive!.toLocal()).toLowerCase()}'
                                : 'Last seen a long time ago',
                            style: const TextStyle(
                              color: AppColor.baseWhiteColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'SF Pro Display',
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                style: const ButtonStyle(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                iconSize: 24,
                icon: SvgPicture.asset(
                  'assets/icons/chat-menu.svg',
                ),
              ),
            ],
          ),
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
            systemNavigationBarColor: AppColor.backgroundColor,
            systemNavigationBarIconBrightness: Brightness.dark,
          ),
          toolbarHeight: 80,
          flexibleSpace: SafeArea(
            child: Container(
              height: 80,
              color: AppColor.primaryColor,
            ),
          ),
        ),
        body: Column(
          children: [
            Flexible(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColor.backgroundColor,
                  image: DecorationImage(
                    image: Image.asset(
                      'assets/images/background-chatroom.png',
                      scale: 4,
                    ).image,
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      AppColor.backgroundColor.withOpacity(
                        0.12,
                      ),
                      BlendMode.hardLight,
                    ),
                  ),
                  border: Border(
                    bottom: BorderSide(
                      width: 1,
                      color: AppColor.primaryColor,
                    ),
                  ),
                ),
                child: Scrollbar(
                  interactive: true,
                  trackVisibility: true,
                  child: PagedListView.separated(
                    pagingController: controller.pagingController!,
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 24,
                    ),
                    reverse: true,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                    builderDelegate: PagedChildBuilderDelegate<Message>(
                      animateTransitions: true,
                      noItemsFoundIndicatorBuilder: (context) =>
                          const SizedBox.shrink(),
                      noMoreItemsIndicatorBuilder: (context) =>
                          const SizedBox.shrink(),
                      itemBuilder: (context, message, index) {
                        if (message.type == MessageType.REQUEST) {
                          return Column(
                            children: [
                              Text(
                                DateFormat.jm()
                                    .format(message.createdAt!.toLocal())
                                    .toLowerCase(),
                                style: const TextStyle(
                                  color: Color(0xFF979393),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'SF Pro Display',
                                ),
                              ),
                              const SizedBox(height: 16),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: message.userId ==
                                          controller
                                              .homeController.user.value.id
                                      ? 'You'
                                      : message.user!.name!.split(' ')[0],
                                  style: const TextStyle(
                                    color: Color(0xFF1A1F36),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  children: const [
                                    TextSpan(
                                      text: ' requested a book swap\n',
                                      style: TextStyle(
                                        color: Color(0xFF1A1F36),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    // TODO: Replace with actual book title
                                    //       and author name from request.
                                    TextSpan(
                                      text:
                                          '“The Golem and the Jinni, Helene Wecker!”',
                                      style: TextStyle(
                                        color: Color(0xFF1A1F36),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (message.userId !=
                                  controller.homeController.user.value.id)
                                const SizedBox(height: 16),
                              if (message.userId !=
                                  controller.homeController.user.value.id)
                                // Button to accept or reject the request.
                                SizedBox(
                                  height: 40,
                                  child: Wrap(
                                    alignment: WrapAlignment.center,
                                    runAlignment: WrapAlignment.center,
                                    children: [
                                      MaterialButton(
                                        onPressed: null,
                                        color: AppColor.secondaryColor,
                                        elevation: 0,
                                        highlightElevation: 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(24),
                                        ),
                                        disabledColor: const Color(0xFFFFC051),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 26,
                                          vertical: 11,
                                        ),
                                        child: const Text(
                                          'Approve',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      MaterialButton(
                                        onPressed: null,
                                        color: AppColor.backgroundColor,
                                        elevation: 0,
                                        highlightElevation: 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(24),
                                          side: const BorderSide(
                                            color: Color(
                                              0xFF808080,
                                            ), // Enable Color(0xFF3D405B),
                                            width: 0.5,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 26,
                                          vertical: 11,
                                        ),
                                        child: const Text(
                                          'Decline',
                                          style: TextStyle(
                                            color: Color(
                                              0xFF808080,
                                            ), // Enable Color AppColor.primaryBlackColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          );
                        }

                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                          ),
                          child: Column(
                            crossAxisAlignment: message.userId ==
                                    controller.homeController.user.value.id
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth: Get.width * 0.8,
                                  minHeight: 53,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 17.5,
                                ),
                                decoration: BoxDecoration(
                                  color: message.userId ==
                                          controller
                                              .homeController.user.value.id
                                      ? const Color(0xFFEBEBEB)
                                      : AppColor.secondaryColor,
                                  borderRadius: BorderRadius.circular(18),
                                  shape: BoxShape.rectangle,
                                ),
                                child: Wrap(
                                  runAlignment: WrapAlignment.center,
                                  children: [
                                    Text(
                                      message.content!,
                                      style: const TextStyle(
                                        color: AppColor.primaryBlackColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                DateFormat.jm()
                                    .format(message.createdAt!.toLocal())
                                    .toLowerCase(),
                                style: const TextStyle(
                                  color: Color(0xFF979393),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'SF Pro Display',
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      firstPageProgressIndicatorBuilder: (context) {
                        return AppWidget.getLoadingIndicator(
                          color: AppColor.primaryColor,
                        );
                      },
                      newPageProgressIndicatorBuilder: (context) {
                        return AppWidget.getLoadingIndicator(
                          color: AppColor.primaryColor,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
                top: 20,
              ),
              color: AppColor.backgroundColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      controller.showEmojiPicker();
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    style: const ButtonStyle(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    iconSize: 24,
                    icon: SvgPicture.asset(
                      'assets/icons/emoticon.svg',
                    ),
                  ),
                  Flexible(
                    child: TextField(
                      controller: controller.messageController,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      onTapOutside: (event) => controller.hideKeyboard(),
                      minLines: 1,
                      maxLines: 20,
                      style: const TextStyle(
                        color: AppColor.primaryBlackColor,
                        fontSize: 18,
                        fontFamily: 'SF Pro Display',
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Type a message',
                        alignLabelWithHint: true,
                        hintStyle: TextStyle(
                          color: Color(0xFF888888),
                          fontSize: 18,
                          fontFamily: 'SF Pro Display',
                        ),
                        fillColor: AppColor.backgroundColor,
                        filled: true,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        prefixIconConstraints: BoxConstraints(),
                      ),
                    ),
                  ),
                  Obx(
                    () {
                      return AnimatedCrossFade(
                        duration: const Duration(milliseconds: 250),
                        layoutBuilder: (
                          topChild,
                          topKey,
                          bottomChild,
                          bottomKey,
                        ) {
                          return Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Positioned(
                                key: bottomKey,
                                top: 0,
                                child: bottomChild,
                              ),
                              Positioned(
                                key: topKey,
                                child: topChild,
                              ),
                            ],
                          );
                        },
                        firstCurve: Curves.easeInOutCubicEmphasized,
                        secondCurve: Curves.easeInOutCubic,
                        crossFadeState: controller.message.value.isEmpty
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        firstChild: Obx(
                          () => AnimatedCrossFade(
                            duration: const Duration(milliseconds: 250),
                            crossFadeState: controller.sending.value
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                            firstChild: IconButton(
                              onPressed: () async {
                                await controller.sendMessage();
                              },
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              style: const ButtonStyle(
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              iconSize: 24,
                              icon: SvgPicture.asset(
                                'assets/icons/send.svg',
                                colorFilter: const ColorFilter.mode(
                                  AppColor.primaryBlackColor,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                            secondChild: SizedBox(
                              width: 24,
                              height: 24,
                              child: AppWidget.getLoadingIndicator(
                                color: AppColor.primaryColor,
                              ),
                            ),
                          ),
                        ),
                        secondChild: Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              style: const ButtonStyle(
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              iconSize: 24,
                              icon: SvgPicture.asset(
                                'assets/icons/document.svg',
                              ),
                            ),
                            const SizedBox(width: 21),
                            IconButton(
                              onPressed: () {},
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              style: const ButtonStyle(
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              iconSize: 24,
                              icon: SvgPicture.asset(
                                'assets/icons/attachment.svg',
                              ),
                            ),
                            const SizedBox(width: 21),
                            IconButton(
                              onPressed: () {},
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              style: const ButtonStyle(
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              iconSize: 24,
                              icon: SvgPicture.asset(
                                'assets/icons/voice.svg',
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Obx(
              () => AnimatedCrossFade(
                excludeBottomFocus: false,
                duration: 250.milliseconds,
                crossFadeState: controller.showEmoji.value
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                firstCurve: Curves.easeInOutCubicEmphasized,
                secondCurve: Curves.easeInOutCubic,
                firstChild: EmojiPicker(
                  textEditingController: controller.messageController,
                  config: Config(
                    checkPlatformCompatibility: true,
                    emojiViewConfig: EmojiViewConfig(
                      // Issue: https://github.com/flutter/flutter/issues/28894
                      emojiSizeMax: 24 * (Platform.isIOS ? 1.20 : 1.0),
                      backgroundColor: AppColor.backgroundColor,
                      loadingIndicator: AppWidget.getLoadingIndicator(
                        color: AppColor.primaryColor,
                      ),
                    ),
                    swapCategoryAndBottomBar: true,
                    skinToneConfig: SkinToneConfig(
                      dialogBackgroundColor: AppColor.backgroundColor,
                      indicatorColor: AppColor.primaryColor,
                    ),
                    categoryViewConfig: CategoryViewConfig(
                      indicatorColor: AppColor.secondaryColor,
                      iconColor: AppColor.primaryBlackColor,
                      iconColorSelected: AppColor.secondaryColor,
                      backgroundColor: AppColor.backgroundColor,
                      dividerColor: AppColor.neutralColor[200]!,
                    ),
                    bottomActionBarConfig: const BottomActionBarConfig(
                      backgroundColor: AppColor.backgroundColor,
                      buttonColor: AppColor.backgroundColor,
                      buttonIconColor: AppColor.primaryBlackColor,
                    ),
                    searchViewConfig: SearchViewConfig(
                      backgroundColor: AppColor.backgroundColor,
                      buttonColor: AppColor.secondaryColor,
                      buttonIconColor: AppColor.primaryBlackColor,
                    ),
                  ),
                ),
                secondChild: const SizedBox.shrink(),
              ),
            ),
            SizedBox(height: Get.mediaQuery.viewPadding.bottom),
          ],
        ),
      ),
    );
  }
}
