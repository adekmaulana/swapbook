import 'package:get/get.dart';

import '../../../data/models/book.model.dart';
import '../../../domain/case/book/get_posts.case.dart';
import '../../controller.dart.dart';
import 'katalog.controller.dart';

class AllKatalogController extends BaseController with StateMixin<List<Book>> {
  @override
  void onInit() {
    super.onInit();

    KatalogController katalogController = Get.find<KatalogController>();
    getBooks({'random': 1});

    debounce(katalogController.selectedFilter, (int value) {
      getBooks({
        katalogController.filterValues[value]!: 1,
      });
    }, time: 1.seconds);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getBooks(Map<String, dynamic> query) async {
    change(null, status: RxStatus.loading());
    try {
      final response = await GetBooksCase().call(query);
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

      change(response.books, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }
}
