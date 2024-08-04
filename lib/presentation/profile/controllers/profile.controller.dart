import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../home/controllers/home.controller.dart';

class ProfileController extends GetxController
    with StateMixin<Map<String, dynamic>> {
  HomeController homeController = Get.find<HomeController>();

  Map<String, dynamic> location = {};

  @override
  void onInit() async {
    super.onInit();

    change(null, status: RxStatus.loading());

    final locationData = homeController.user.value.location;
    if (locationData == null) {
      change(null, status: RxStatus.success());
      return;
    }

    List<Placemark> placemarks = await placemarkFromCoordinates(
      locationData.latitude!,
      locationData.longitude!,
    );
    location = placemarks.first.toJson();
    change(location, status: RxStatus.success());
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
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
