import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:pull_to_refresh_new/pull_to_refresh.dart';

import '../../infrastructure/navigation/routes.dart';
import '../../infrastructure/theme/app.color.dart';
import '../../infrastructure/theme/app.widget.dart';
import '../home/wrapper.home.screen.dart';
import 'controllers/all_katalog.controller.dart';
import 'controllers/new_katalog.controller.dart';
import 'controllers/katalog.controller.dart';
import 'package:swapbook/data/models/book.model.dart';

class KatalogScreen extends GetView<KatalogController> {
  const KatalogScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return WrapperHomeScreen(
      backgroundImage: 'assets/images/background-katalog.png',
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          titleSpacing: 24,
          title: Row(
            children: [
              SizedBox(
                child: IconButton(
                  onPressed: () {
                    controller.openDrawer();
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  style: const ButtonStyle(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  iconSize: 24,
                  icon: SvgPicture.asset(
                    'assets/icons/drawer.svg',
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                child: IconButton(
                  onPressed: () {
                    Get.toNamed(Routes.POST);
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  style: const ButtonStyle(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  iconSize: 24,
                  icon: SvgPicture.asset(
                    'assets/icons/camera.svg',
                  ),
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                child: Stack(
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
                        'assets/icons/notification.svg',
                      ),
                    ),
                    Positioned(
                      right: 4,
                      top: 4,
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Color(0xFFDE0639),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
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
          automaticallyImplyLeading: false,
        ),
        body: GetBuilder(
          init: controller,
          builder: (context) {
            final AllKatalogController allKatalogController =
                Get.find<AllKatalogController>();
            final NewKatalogController newKatalogController =
                Get.find<NewKatalogController>();
            return Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(
                    right: 32,
                    left: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => RichText(
                          text: TextSpan(
                            text: 'Good ${controller.greeting.value}, ',
                            style: const TextStyle(
                              color: AppColor.primaryBlackColor,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                            children: [
                              TextSpan(
                                text:
                                    '${controller.homeController.user.value.name!.split(' ')[0]}!',
                                style: TextStyle(
                                  color: AppColor.secondaryColor,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Obx(
                          () => AnimatedSwitcher(
                            duration: 1.seconds,
                            layoutBuilder: (
                              Widget? currentChild,
                              List<Widget> previousChildren,
                            ) {
                              return currentChild!;
                            },
                            transitionBuilder: (child, animation) {
                              final offsetAnimation = TweenSequence([
                                TweenSequenceItem(
                                  tween: Tween<Offset>(
                                    begin: const Offset(0.0, 1.0),
                                    end: const Offset(0.0, 0.0),
                                  ),
                                  weight: 2,
                                ),
                                TweenSequenceItem(
                                  tween: ConstantTween(
                                    const Offset(0.0, 0.0),
                                  ),
                                  weight: 6,
                                ),
                                TweenSequenceItem(
                                  tween: Tween<Offset>(
                                    begin: const Offset(0.0, 0.0),
                                    end: const Offset(0.0, 0.0),
                                  ),
                                  weight: 2,
                                )
                              ]).animate(animation);
                              return ClipRect(
                                child: SlideTransition(
                                  position: offsetAnimation,
                                  child: child,
                                ),
                              );
                            },
                            child: Text(
                              key: UniqueKey(),
                              controller.subtitle.value,
                              style: const TextStyle(
                                color: AppColor.borderColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 42,
                  child: ListView.separated(
                    itemCount: controller.filters.length,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(
                      left: 24,
                    ),
                    itemBuilder: (context, index) {
                      return Obx(
                        () {
                          return InkWell(
                            onTap: () {
                              if (controller.selectedFilter.value == index) {
                                return;
                              }

                              controller.selectedFilter.value = index;
                            },
                            splashColor: AppColor.secondaryColor.withOpacity(
                              0.1,
                            ),
                            highlightColor: AppColor.secondaryColor.withOpacity(
                              0.1,
                            ),
                            customBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: AnimatedContainer(
                              duration: 300.milliseconds,
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    controller.selectedFilter.value == index
                                        ? 36
                                        : 0,
                              ),
                              decoration: BoxDecoration(
                                color: controller.selectedFilter.value == index
                                    ? AppColor.primaryColor
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(
                                  20,
                                ),
                              ),
                              child: controller.selectedFilter.value == index
                                  ? Text(
                                      controller.filters[index],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.06,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    )
                                  : Text(
                                      controller.filters[index],
                                      style: const TextStyle(
                                        color: Color(0xFF7D7D7D),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                            ),
                          );
                        },
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Obx(
                        () {
                          if (controller.selectedFilter.value == index) {
                            return const SizedBox(width: 23.39);
                          }

                          return const SizedBox(width: 24);
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: SmartRefresher(
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
                    onRefresh: () async {
                      try {
                        await Future.wait([
                          allKatalogController.getBooks(
                            {
                              controller.filterValues[
                                  controller.selectedFilter.value]!: 1,
                            },
                          ),
                          newKatalogController.getBooks(),
                        ]);

                        controller.refreshController.refreshCompleted();
                      } catch (e) {
                        controller.refreshController.refreshFailed();
                      }
                    },
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: 360,
                            width: double.infinity,
                            child: allKatalogController.obx(
                              onLoading: AppWidget.getLoadingIndicator(
                                color: AppColor.primaryColor,
                              ),
                              onError: (error) {
                                return Center(
                                  child: Text(
                                    error ?? 'An error occurred',
                                    style: const TextStyle(
                                      color: Color(0xFF7D7D7D),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                );
                              },
                              onEmpty: const Center(
                                child: Text(
                                  'No posts found',
                                  style: TextStyle(
                                    color: Color(0xFF7D7D7D),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              (state) {
                                return _buildKatalog(state);
                              },
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Container(
                            margin: const EdgeInsets.only(
                              left: 24,
                            ),
                            child: const Text(
                              'New Upload',
                              style: TextStyle(
                                color: AppColor.primaryBlackColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SliverToBoxAdapter(
                          child: SizedBox(height: 24),
                        ),
                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: 360,
                            width: double.infinity,
                            child: newKatalogController.obx(
                              onLoading: AppWidget.getLoadingIndicator(
                                color: AppColor.secondaryColor,
                              ),
                              onError: (error) {
                                return Center(
                                  child: Text(
                                    error ?? 'An error occurred',
                                  ),
                                );
                              },
                              onEmpty: const Center(
                                child: Text('No posts found'),
                              ),
                              (state) {
                                return _buildKatalog(state);
                              },
                            ),
                          ),
                        ),
                        const SliverToBoxAdapter(
                          child: SizedBox(
                            height: kBottomNavigationBarHeight + 40,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildKatalog(List<Book>? books) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(
        left: 24,
        right: 24,
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
                height: 230,
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
    );
  }
}
