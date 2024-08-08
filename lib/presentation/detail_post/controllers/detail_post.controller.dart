import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:swapbook/infrastructure/services/pusher.service.dart';
import 'package:swapbook/infrastructure/theme/app.widget.dart';

import '../../../data/models/book.model.dart';
import '../../../domain/case/book/bookmark.case.dart';
import '../../../domain/case/book/get_post.case.dart';
import '../../../domain/case/chat/create_chat.case.dart';
import '../../../domain/case/message/send_message.case.dart';
import '../../../infrastructure/constant.dart';
import '../../../infrastructure/navigation/routes.dart';
import '../../controller.dart.dart';
import '../../home/controllers/home.controller.dart';

class DetailPostController extends BaseController with StateMixin<Book> {
  HomeController homeController = Get.find<HomeController>();

  Map<String, dynamic> location = {};
  Book? get book => state;

  RxBool isBookmarked = false.obs;
  @override
  void onInit() async {
    super.onInit();

    final args = Get.arguments as Map<String, dynamic>;
    final id = args['book_id'] as int;

    if (id != homeController.user.value.id) {
      final token = await localRepository.get(
        LocalRepositoryKey.TOKEN,
        '',
      );

      if (token.isEmpty) {
        return;
      }

      EchoService.init(token);
    }

    await getBook(id);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getBook(int id) async {
    change(null, status: RxStatus.loading());
    try {
      final response = await GetBookCase().call(id);
      if (response.meta?.code != 200) {
        change(
          null,
          status: RxStatus.error(response.meta?.messages?.first),
        );
        return;
      }

      if (response.book == null) {
        change(null, status: RxStatus.empty());
        return;
      }

      final userData = response.book!.user;
      if (userData?.location?.latitude != null &&
          userData?.location?.longitude != null) {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          userData!.location!.latitude!,
          userData.location!.longitude!,
        );

        location = placemarks.first.toJson();
      }

      isBookmarked.value = response.book!.isBookmarked!;
      change(response.book, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  Future<void> goToChat(int userId) async {
    showLoading(true);
    try {
      final response = await CreateChatCase()(userId);
      if (response.meta!.code != 200) {
        AppWidget.openSnackbar(
          "Oops! Something went wrong",
          response.meta!.messages!.first,
        );
        return;
      }

      if (response.chat == null) {
        AppWidget.openSnackbar(
          "Oops! Something went wrong",
          "We couldn't create a chat room for you now. Please try again later.",
        );
        return;
      }

      Get.toNamed(
        Routes.CHAT_ROOM,
        arguments: {
          'chat': response.chat,
          'user': state!.user,
        },
      );
    } catch (e) {
      AppWidget.openSnackbar(
        "Oops! Something went wrong",
        "Please try again later.",
      );
    } finally {
      showLoading(false);
    }
  }

  Future<void> requestSwap(int bookId, int userId) async {
    showLoading(true);
    try {
      final response = await CreateChatCase()(userId);
      if (response.meta!.code != 200) {
        AppWidget.openSnackbar(
          "Oops! Something went wrong",
          response.meta!.messages!.first,
        );
        return;
      }

      if (response.chat == null) {
        AppWidget.openSnackbar(
          "Oops! Something went wrong",
          "We couldn't send request for you now. Please try again later.",
        );
        return;
      }

      try {
        final res = await SendMessageCase().call(
          response.chat!.id!,
          "I want to swap this book with you.",
          EchoService.socketId,
          type: 'request',
          data: {
            'book_id': bookId,
          },
        );

        if (res.meta?.code != 200) {
          AppWidget.openSnackbar(
            "Oops! Something went wrong",
            res.meta?.messages?.first ?? "Please try again later.",
          );
          return;
        }

        AppWidget.openSnackbar(
          "Request sent",
          "Your request has been sent successfully.",
          type: SnackBarStatus.success,
        );
      } catch (e, s) {
        print(e);
        print(s);
        AppWidget.openSnackbar(
          "Oops! Something went wrong",
          "We couldn't send request for you now. Please try again later.",
        );
      }
    } catch (e, s) {
      print(e);
      print(s);
      AppWidget.openSnackbar(
        "Oops! Something went wrong",
        "Please try again later.",
      );
    } finally {
      showLoading(false);
    }
  }

  Future<bool> bookmark() async {
    try {
      final response = await BookmarkBookCase().call(
        state!.id!,
        {
          'post_id': state!.id,
        },
      );

      if (response.meta?.code != 200) {
        AppWidget.openSnackbar(
          "Oops! Something went wrong",
          response.meta?.messages?.first ?? "Please try again later.",
        );
        return false;
      }

      if (response.bookmarked == null) {
        AppWidget.openSnackbar(
          "Oops! Something went wrong",
          "We couldn't bookmark this book now. Please try again later.",
        );
        return false;
      }

      return response.bookmarked!;
    } catch (e) {
      AppWidget.openSnackbar(
        "Oops! Something went wrong",
        "Please try again later.",
      );

      return false;
    }
  }
}
