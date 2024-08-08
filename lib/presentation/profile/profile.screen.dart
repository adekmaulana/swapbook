import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pull_to_refresh_new/pull_to_refresh.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../../data/models/book.model.dart';
import '../../infrastructure/theme/app.color.dart';
import '../../infrastructure/theme/app.widget.dart';
import '../home/wrapper.home.screen.dart';
import 'controllers/profile.controller.dart';
import 'profile.appbar.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return WrapperHomeScreen(
      backgroundImage: 'assets/images/background-search.png',
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        body: controller.obx(
          (state) {
            final books = state!['books'] as List<Book>;
            return NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverOverlapAbsorber(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                      context,
                    ),
                    sliver: SliverPersistentHeader(
                      delegate: ProfileAppBar(),
                      pinned: true,
                      floating: false,
                    ),
                  ),
                ];
              },
              body: LayoutBuilder(
                builder: (context, constraints) {
                  return CustomScrollView(
                    slivers: [
                      SliverOverlapInjector(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                          context,
                        ),
                      ),
                      SliverFillRemaining(
                        hasScrollBody: false,
                        fillOverscroll: false,
                        child: SizedBox(
                          height: constraints.maxHeight,
                          child: Column(
                            children: [
                              Expanded(
                                child: _buildKatalog(books),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          },
          onLoading: Center(
            child: AppWidget.getLoadingIndicator(
              color: AppColor.primaryColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKatalog(List<Book>? books) {
    return SmartRefresher(
      controller: controller.refreshController,
      onRefresh: () {
        controller.onRefresh();
      },
      header: Platform.isIOS
          ? const ClassicHeader(
              textStyle: TextStyle(
                color: Color(0xFF7D7D7D),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            )
          : const MaterialClassicHeader(),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
        ),
        itemCount: books!.length,
        itemBuilder: (context, index) {
          final book = books[index];

          // Wrapping the children widget with
          // GestureDetector, to avoid pressing empty space.
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  controller.goToDetailPost(book.id!);
                },
                child: Container(
                  height: 161,
                  width: 161,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      20,
                    ),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0D06070D),
                        offset: Offset(0, 7),
                        blurRadius: 14,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      20,
                    ),
                    child: CachedNetworkImage(
                      imageUrl: book.image ?? book.imageLink ?? '',
                      fit: BoxFit.fill,
                      placeholder: (context, url) {
                        return AppWidget.getLoadingIndicator(
                          color: AppColor.secondaryColor,
                        );
                      },
                      errorWidget: (
                        context,
                        url,
                        error,
                      ) {
                        return const Center(
                          child: Icon(
                            Icons.error_rounded,
                            color: Colors.red,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  controller.goToDetailPost(book.id!);
                },
                child: SizedBox(
                  width: 161,
                  child: Wrap(
                    children: [
                      Text(
                        book.title!,
                        style: const TextStyle(
                          color: AppColor.primaryBlackColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                      Text(
                        book.author!.first,
                        style: const TextStyle(
                          color: Color(0xFF9D9D9D),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(width: 20);
        },
      ),
    );
  }
}
