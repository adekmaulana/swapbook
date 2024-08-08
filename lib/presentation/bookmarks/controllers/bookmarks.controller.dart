import 'package:get/get.dart';
import 'package:pull_to_refresh_new/pull_to_refresh.dart';

import '../../../data/models/book.model.dart';
import '../../../domain/case/book/get_posts.case.dart';
import '../../../infrastructure/navigation/routes.dart';
import '../../../infrastructure/theme/app.widget.dart';
import '../../controller.dart.dart';
import '../../detail_post/controllers/detail_post.controller.dart';
import '../../screens.dart';

class BookmarksController extends BaseController with StateMixin<List<Book>> {
  RefreshController refreshController = RefreshController(
    initialRefresh: false,
  );

  @override
  void onInit() {
    super.onInit();

    getBooks();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
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

  Future<void> getBooks() async {
    change(null, status: RxStatus.loading());
    try {
      final response = await GetBooksCase().call({'bookmarks': 1});
      if (response.meta?.code != 200) {
        if (response.meta?.code == 422) {
          change(
            null,
            status: RxStatus.error(
              response.meta?.validations?.first.message?.first,
            ),
          );
          return;
        }
        change(
          null,
          status: RxStatus.error(response.meta?.messages?.first),
        );
        return;
      }

      if (response.books == null || response.books?.isEmpty == true) {
        change(null, status: RxStatus.empty());
        return;
      }

      refreshController.refreshCompleted();
      change(response.books, status: RxStatus.success());
    } catch (e) {
      refreshController.refreshFailed();
      change(null, status: RxStatus.error(e.toString()));
    }
  }
}
