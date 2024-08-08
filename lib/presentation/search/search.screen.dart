import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide SearchController;
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../../data/models/book.model.dart';
import '../../infrastructure/theme/app.color.dart';
import '../../infrastructure/theme/app.widget.dart';
import '../home/wrapper.home.screen.dart';
import 'controllers/search.controller.dart';

class SearchScreen extends GetView<SearchController> {
  const SearchScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return WrapperHomeScreen(
      backgroundImage: 'assets/images/background-search.png',
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          toolbarHeight: 16,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
            systemNavigationBarColor: AppColor.backgroundColor,
            systemNavigationBarIconBrightness: Brightness.dark,
          ),
        ),
        body: Container(
          margin: const EdgeInsets.only(
            left: 24,
            right: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                textAlignVertical: TextAlignVertical.center,
                controller: controller.searchController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.search,
                cursorColor: const Color(0xFF666666),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(
                    left: 16,
                    top: 13,
                    bottom: 13,
                  ),
                  hintText: 'Search...',
                  hintStyle: const TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 14,
                    fontWeight: FontWeight.w200,
                  ),
                  filled: true,
                  fillColor: AppColor.backgroundColor,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(
                      right: 18,
                      left: 13,
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/search-page.svg',
                      width: 20,
                      height: 20,
                    ),
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      return;
                      // controller.openFilter();
                    },
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all(
                        const EdgeInsets.all(0),
                      ),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    iconSize: 20,
                    icon: SvgPicture.asset(
                      'assets/icons/equalizer.svg',
                      width: 20,
                      height: 20,
                    ),
                  ),
                  suffixIconConstraints: const BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: AppColor.borderColor,
                      width: 1,
                    ),
                  ),
                ),
                style: const TextStyle(
                  color: AppColor.primaryBlackColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Expanded(
                child: SafeArea(
                  child: Obx(
                    () {
                      if (controller.isSearching.value) {
                        return Center(
                          child: AppWidget.getLoadingIndicator(
                            color: AppColor.secondaryColor,
                          ),
                        );
                      }

                      if (controller.books.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      return _buildKatalog(controller.books);
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKatalog(List<Book>? books) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(
        top: 24,
        bottom: 24,
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
