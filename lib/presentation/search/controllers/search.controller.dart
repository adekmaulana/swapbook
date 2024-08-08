import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../data/models/book.model.dart';
import '../../../domain/case/book/get_posts.case.dart';
import '../../../infrastructure/navigation/routes.dart';
import '../../../infrastructure/theme/app.color.dart';
import '../../../infrastructure/theme/app.widget.dart';
import '../../detail_post/controllers/detail_post.controller.dart';
import '../../detail_post/detail_post.screen.dart';

class SearchController extends GetxController {
  TextEditingController searchController = TextEditingController();

  RxString searchQuery = ''.obs;
  RxList<Book> books = RxList<Book>([]);
  RxBool isSearching = false.obs;
  @override
  void onInit() {
    super.onInit();

    searchController.addListener(() {
      searchQuery.value = searchController.text;
    });

    debounce(
      searchQuery,
      (String query) {
        if (query.isEmpty) {
          return;
        }

        if (query.length < 3) {
          return;
        }

        getBooks(query);
      },
      time: 500.milliseconds,
    );
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getBooks(String query) async {
    isSearching.value = true;
    try {
      final response = await GetBooksCase().call({
        'q': query,
      });
      if (response.meta?.code != 200) {
        if (response.meta?.code == 422) {
          books.value = [];
          return;
        }

        AppWidget.openSnackbar(
          'Oops! Something went wrong.',
          response.meta?.messages?.first ?? 'Failed to get books',
        );
        books.value = [];
        return;
      }

      if (response.books == null || response.books?.isEmpty == true) {
        books.value = [];
        return;
      }

      books.value = response.books!;
    } catch (e) {
      AppWidget.openSnackbar(
        'Oops! Something went wrong.',
        'Failed to get books',
      );
      books.value = [];
    } finally {
      isSearching.value = false;
      books.refresh();
    }
  }

  Future<T?> openFilter<T>() async {
    return AppWidget.showBottomSheet<T>(
      removeBackground: true,
      child: Scaffold(
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
        body: Container(
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
                      'Filter',
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
            ],
          ),
        ),
      ),
    );
  }

  Future<void> goToDetailPost(int id) async {
    Get.lazyPut(
      () => DetailPostController(),
    );
    return await AppWidget.showBottomSheet(
      child: const DetailPostScreen(),
      routeName: Routes.DETAIL_POST,
      arguments: {
        'book_id': id,
      },
    );
  }
}
