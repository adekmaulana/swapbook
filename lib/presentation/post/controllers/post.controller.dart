import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../infrastructure/theme/app.color.dart';
import '../../../infrastructure/theme/app.widget.dart';
import '../../controller.dart.dart';

class PostController extends BaseController {
  TextEditingController titleController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController genreController = TextEditingController();
  TextEditingController synopsisController = TextEditingController();

  Rx<String?> selectedImage = Rx<String?>(null);
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
    titleController.dispose();
    authorController.dispose();
    genreController.dispose();
    synopsisController.dispose();
    super.onClose();
  }

  Future<void> pickImage() async {
    showLoading(true);
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) {
      showLoading(false);
      return;
    }

    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
      aspectRatio: const CropAspectRatio(
        ratioX: 1,
        ratioY: 1,
      ),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
          statusBarColor: AppColor.primaryBlackColor,
          backgroundColor: AppColor.backgroundColor,
          toolbarColor: AppColor.secondaryColor,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
          ],
        ),
        IOSUiSettings(
          title: 'Cropper',
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
          ],
        ),
      ],
    );

    if (croppedFile == null) {
      showLoading(false);
      return;
    }

    if (!await File(croppedFile.path).exists()) {
      AppWidget.openSnackbar(
        'Oops! Something went wrong.',
        'Could not load image. Please try again.',
      );
      showLoading(false);
      return;
    }

    showLoading(false);
    selectedImage.value = croppedFile.path;
  }

  Future<void> showImage() async {
    if (selectedImage.value == null) {
      return;
    }
  }
}
