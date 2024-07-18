import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh_new/pull_to_refresh.dart';

import '../../data/models/chat.model.dart';
import '../../infrastructure/navigation/routes.dart';
import '../../infrastructure/theme/app.color.dart';
import '../../infrastructure/theme/app.widget.dart';
import '../home/wrapper.home.screen.dart';
import 'controllers/chat.controller.dart';

class ChatScreen extends GetView<ChatController> {
  const ChatScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return WrapperHomeScreen(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          toolbarHeight: 80,
          flexibleSpace: SafeArea(
            child: Container(
              height: 80,
              color: AppColor.primaryColor,
              padding: const EdgeInsets.only(left: 24, right: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      controller.searchUser();
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    style: const ButtonStyle(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    iconSize: 24,
                    icon: SvgPicture.asset(
                      'assets/icons/new-chat.svg',
                    ),
                  ),
                  const Text(
                    'Chat',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    style: const ButtonStyle(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    iconSize: 16,
                    icon: SvgPicture.asset(
                      'assets/icons/toolbar.svg',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: SmartRefresher(
          enablePullDown: true,
          controller: controller.refreshController,
          onRefresh: controller.pagingController!.refresh,
          primary: true,
          header: WaterDropMaterialHeader(
            backgroundColor: AppColor.primaryColor,
            color: Colors.white,
            distance: 20.0,
          ),
          child: GetBuilder<ChatController>(
            init: controller,
            builder: (context) {
              return PagedListView.separated(
                physics: const BouncingScrollPhysics(),
                pagingController: controller.pagingController!,
                separatorBuilder: (context, index) => const SizedBox(
                  height: 32,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 36,
                ),
                builderDelegate: PagedChildBuilderDelegate<Chat>(
                  firstPageProgressIndicatorBuilder: (context) =>
                      AppWidget.getLoadingIndicator(
                    color: AppColor.primaryColor,
                  ),
                  newPageProgressIndicatorBuilder: (context) =>
                      const SizedBox.shrink(),
                  itemBuilder: (context, item, index) {
                    final chat = item;
                    final participant = chat.participants!.firstWhere(
                      (element) => element.userId != controller.self.value.id,
                    );
                    final user = participant.user;
                    ImageProvider? avatar;
                    if (user!.photoURL != null) {
                      avatar = CachedNetworkImageProvider(user.photoURL!);
                    } else {
                      if (user.gender == "L") {
                        avatar = const AssetImage(
                          'assets/images/avatar-man.png',
                        );
                      } else if (user.gender == "P") {
                        avatar = const AssetImage(
                          'assets/images/avatar-woman.png',
                        );
                      } else {
                        avatar = const AssetImage(
                          'assets/images/avatar-man.png',
                        );
                      }
                    }
                    return InkWell(
                      onTap: () {
                        Get.toNamed(
                          Routes.CHAT_ROOM,
                          arguments: {
                            'chat': chat,
                          },
                        );
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 38,
                            width: 38,
                            child: CircleAvatar(
                              backgroundColor: const Color(0xFFFABCA6),
                              backgroundImage: avatar,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              height: 54,
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color(0x66808080),
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          participant.user!.name!,
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          chat.lastMessage!.content!,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF9B9B9B),
                                            fontWeight: FontWeight.w700,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        DateFormat.Hm().format(
                                          chat.lastMessage!.updatedAt!
                                              .toLocal(),
                                        ),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColor.secondaryColor,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      if (chat.unreadCount != null &&
                                          chat.unreadCount! > 0)
                                        const SizedBox(height: 4),
                                      if (chat.unreadCount != null &&
                                          chat.unreadCount! > 0)
                                        Flexible(
                                          child: Container(
                                            height: 18,
                                            width: 18,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: AppColor.secondaryColor,
                                              shape: BoxShape.circle,
                                            ),
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                chat.unreadCount.toString(),
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                ),
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
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
