import 'package:get/get.dart';

import '../../../../presentation/forgot_pass/controllers/forgot_pass.controller.dart';

class ForgotPassControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgotPassController>(
      () => ForgotPassController(),
    );
  }
}
