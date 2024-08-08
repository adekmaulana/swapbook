import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:pull_to_refresh_new/pull_to_refresh.dart';

import '../../data/models/book.model.dart';
import '../../infrastructure/theme/app.color.dart';
import '../../infrastructure/theme/app.widget.dart';
import '../home/wrapper.home.screen.dart';
import 'controllers/bookmarks.controller.dart';

class BookmarksScreen extends GetView<BookmarksController> {
  const BookmarksScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return WrapperHomeScreen(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text(
            'Saved Books',
            style: TextStyle(
              color: AppColor.primaryBlackColor,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: false,
          titleSpacing: 24,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
            systemNavigationBarColor: AppColor.backgroundColor,
            systemNavigationBarIconBrightness: Brightness.dark,
          ),
        ),
        body: SmartRefresher(
          controller: controller.refreshController,
          header: Platform.isIOS
              ? const ClassicHeader(
                  textStyle: TextStyle(
                    color: Color(0xFF7D7D7D),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                )
              : const MaterialClassicHeader(),
          onRefresh: controller.getBooks,
          child: controller.obx(
            (state) {
              return _buildKatalog(state);
            },
            onLoading: AppWidget.getLoadingIndicator(),
            onError: (error) {
              return Center(
                child: Text(
                  error ?? 'An error occurred',
                  style: const TextStyle(
                    color: AppColor.primaryBlackColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              );
            },
            onEmpty: const Center(
              child: Text(
                'No saved books',
                style: TextStyle(
                  color: AppColor.primaryBlackColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKatalog(List<Book>? books) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
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
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                controller.goToDetailPost(book.id!);
              },
              child: Container(
                height: 160,
                width: 160,
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
            const SizedBox(width: 21),
            GestureDetector(
              onTap: () {
                controller.goToDetailPost(book.id!);
              },
              child: SizedBox(
                width: 160,
                height: 160,
                child: Wrap(
                  runSpacing: 6,
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
                      'by ${book.author!.first}',
                      style: const TextStyle(
                        color: Color(0xFF9D9D9D),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    Text(
                      book.synopsis!,
                      style: const TextStyle(
                        color: Color(0xFF9D9D9D),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    Text(
                      'Posted by ${book.user!.name!.split(' ')[0]}',
                      style: TextStyle(
                        color: AppColor.primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
      separatorBuilder: (context, index) {
        return Column(
          children: [
            const SizedBox(height: 24),
            Container(
              color: AppColor.borderColor,
              constraints: const BoxConstraints(
                minWidth: double.infinity,
                minHeight: 1,
              ),
            ),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }
}
