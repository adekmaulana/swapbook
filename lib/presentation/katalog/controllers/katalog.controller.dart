import 'dart:math';

import 'package:get/get.dart';
import 'package:pull_to_refresh_new/pull_to_refresh.dart';

import '../../../infrastructure/navigation/routes.dart';
import '../../../infrastructure/theme/app.widget.dart';
import '../../controller.dart.dart';
import '../../detail_post/controllers/detail_post.controller.dart';
import '../../detail_post/detail_post.screen.dart';
import '../../home/controllers/home.controller.dart';

class KatalogController extends BaseController {
  HomeController homeController = Get.find<HomeController>();
  RefreshController refreshController = RefreshController(
    initialRefresh: false,
  );

  RxInt selectedFilter = 0.obs;
  RxString subtitle = ''.obs;
  RxString greeting = ''.obs;

  List<String> filters = [
    'All',
    'Near Me',
  ];
  Map<int, String> filterValues = {
    0: 'random',
    1: 'nearby',
  };
  List<String> randomSubtitle = [
    "Discover Your Next Favorite Book",
    "Exchange Books with Fellow Readers",
    "Start Your Book Adventure Today",
    "Find, Swap, and Enjoy New Reads",
    "Your Book Journey Begins Here",
    "Unlock a World of Stories",
    "Connect Through Books",
    "Swap, Read, Repeat",
    "Explore New Titles Daily",
    "Where Book Lovers Unite",
    "Discover a world of news that matters to you",
  ];

  final Random _random = Random();

  @override
  void onInit() {
    super.onInit();

    subtitle.value = randomSubtitle[_random.nextInt(randomSubtitle.length)];
    greeting.value = getGreeting();
    Stream.periodic(
      30.minutes,
    ).listen((count) {
      subtitle.value = randomSubtitle[_random.nextInt(randomSubtitle.length)];
      greeting.value = getGreeting();
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();

    refreshController.dispose();
  }

  void openDrawer() {
    homeController.scaffoldKey.currentState?.openDrawer();
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

  String getGreeting() {
    var hour = DateTime.now().hour;
    if (hour > 3 && hour < 12) {
      return 'Morning';
    }

    if (hour < 17) {
      return 'Afternoon';
    }

    if (hour < 21) {
      return 'Evening';
    }

    return 'Night';
  }
}
