import 'package:get/get.dart';

import '../data/repositories/local.repository.dart';

class BaseController extends GetxController {
  bool isLoading = false;

  final LocalRepository localRepository = Get.find<LocalRepository>();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void showLoading(bool show) {
    isLoading = show;
    update();
  }
}
