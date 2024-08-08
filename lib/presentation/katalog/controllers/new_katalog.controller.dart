import 'package:get/get.dart';

import '../../../data/models/book.model.dart';
import '../../../domain/case/book/get_posts.case.dart';
import '../../controller.dart.dart';

class NewKatalogController extends BaseController with StateMixin<List<Book>> {
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

  Future<void> getBooks() async {
    change(null, status: RxStatus.loading());
    try {
      final response = await GetBooksCase().call({'newest': 1});
      if (response.meta?.code != 200) {
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

      change(response.books, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }
}
