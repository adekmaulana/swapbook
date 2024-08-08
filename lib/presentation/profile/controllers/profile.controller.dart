import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_new/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/models/book.model.dart';
import '../../../domain/case/book/get_posts.case.dart';
import '../../../infrastructure/navigation/routes.dart';
import '../../../infrastructure/theme/app.widget.dart';
import '../../detail_post/controllers/detail_post.controller.dart';
import '../../detail_post/detail_post.screen.dart';
import '../../home/controllers/home.controller.dart';

class ProfileController extends GetxController
    with StateMixin<Map<String, dynamic>> {
  HomeController homeController = Get.find<HomeController>();
  RefreshController refreshController = RefreshController(
    initialRefresh: false,
  );

  Map<String, dynamic> location = {};

  @override
  void onInit() async {
    super.onInit();

    change(null, status: RxStatus.loading());
    Map<String, dynamic>? data = {};

    List<Book>? books = await getBooks();
    data = {
      'books': books,
    };

    final locationData = homeController.user.value.location;
    if (locationData == null) {
      change(data, status: RxStatus.success());
      return;
    }

    List<Placemark> placemarks = await placemarkFromCoordinates(
      locationData.latitude!,
      locationData.longitude!,
    );
    location = placemarks.first.toJson();
    data['location'] = location;
    change(data, status: RxStatus.success());
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void onRefresh() {
    try {
      getBooks().then((value) {
        change(
          {
            'books': value,
            'location': location,
          },
          status: RxStatus.success(),
        );
      });

      refreshController.refreshCompleted();
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));

      refreshController.refreshFailed();
    }
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

  Future<List<Book>?> getBooks() async {
    try {
      final response = await GetBooksCase().call({'me': 1});
      if (response.meta?.code != 200) {
        return [];
      }

      if (response.books == null || response.books?.isEmpty == true) {
        return [];
      }

      return response.books;
    } catch (e) {
      return [];
    }
  }

  Future<void> openX() async {
    if (homeController.user.value.twitter == null) {
      return;
    }

    final Uri url = Uri.parse(
      'https://x.com/${homeController.user.value.twitter!}',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> openInstagram() async {
    if (homeController.user.value.instagram == null) {
      return;
    }

    final Uri url = Uri.parse(
      'https://instagram.com/${homeController.user.value.instagram!}',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }
}
