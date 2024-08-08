import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/models/user.model.dart';
import '../../../domain/case/user/update.case.dart';
import '../../../infrastructure/constant.dart';
import '../../../infrastructure/theme/app.color.dart';
import '../../../infrastructure/theme/app.widget.dart';
import '../../controller.dart.dart';
import '../../home/controllers/home.controller.dart';

class EditProfileController extends BaseController {
  final HomeController homeController = Get.find<HomeController>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController instagramController = TextEditingController();
  final TextEditingController twitterController = TextEditingController();

  Rx<String?> nameError = Rx<String?>(null);
  Rx<String?> usernameError = Rx<String?>(null);
  Rx<String?> currentPasswordError = Rx<String?>(null);
  Rx<String?> passwordError = Rx<String?>(null);
  Rx<String?> confirmPasswordError = Rx<String?>(null);
  Rx<String?> instagramError = Rx<String?>(null);
  Rx<String?> twitterError = Rx<String?>(null);

  Rx<String?> selectedImage = Rx<String?>(null);
  Rx<int?> selectedGender = Rx<int?>(null);
  RxString choosenUsername = ''.obs;

  Map<int, String> genderList = {
    0: 'L',
    1: 'P',
  };

  @override
  void onInit() {
    super.onInit();

    nameController.text = homeController.user.value.name!;
    usernameController.text = homeController.user.value.username ?? '';
    instagramController.text = homeController.user.value.instagram ?? '';
    twitterController.text = homeController.user.value.twitter ?? '';

    if (homeController.user.value.gender != null) {
      selectedGender.value = genderList.entries
          .firstWhere(
            (element) => element.value == homeController.user.value.gender,
          )
          .key;
    }

    usernameController.addListener(() {
      choosenUsername.value = usernameController.text;
    });

    debounce(
      choosenUsername,
      (String value) async {
        if (value.isEmpty) {
          return;
        }

        try {
          final response = await UpdateUserCase().call(
            FormData.fromMap(
              {
                'username': value.replaceAll('@', ''),
                'check_only': true,
              },
            ),
          );

          if (response.meta?.code != 200) {
            if (response.meta?.validations != null &&
                response.meta!.validations!.isNotEmpty) {
              usernameError.value =
                  response.meta?.validations?.first.message?.first;
              return;
            }
          }

          usernameError.value = null;
        } catch (e) {
          return;
        }
      },
    );
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    nameController.dispose();
    usernameController.dispose();
    currentPasswordController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    instagramController.dispose();
    twitterController.dispose();
    super.onClose();
  }

  Future<void> saveProfile() async {
    showLoading(true);
    try {
      final response = await UpdateUserCase().call(
        FormData.fromMap(
          {
            if (selectedImage.value != null)
              'image': await MultipartFile.fromFile(
                selectedImage.value!,
                filename: selectedImage.value!.split('/').last,
              ),
            if (nameController.text.isNotEmpty &&
                nameController.text != homeController.user.value.name)
              'name': nameController.text,
            if (usernameController.text.isNotEmpty &&
                usernameController.text != homeController.user.value.username)
              'username': usernameController.text.replaceAll('@', ''),
            if (instagramController.text.isNotEmpty &&
                instagramController.text != homeController.user.value.instagram)
              'instagram': instagramController.text.replaceAll('@', ''),
            if (twitterController.text.isNotEmpty &&
                twitterController.text != homeController.user.value.twitter)
              'twitter': twitterController.text.replaceAll('@', ''),
            if (selectedGender.value != null &&
                genderList[selectedGender.value!] !=
                    homeController.user.value.gender)
              'gender': genderList[selectedGender.value!]!,
            if (currentPasswordController.text.isNotEmpty)
              'current_password': currentPasswordController.text,
            if (passwordController.text.isNotEmpty)
              'new_password': passwordController.text,
            if (confirmPasswordController.text.isNotEmpty)
              'new_password_confirmation': confirmPasswordController.text,
          },
        ),
      );

      if (response.meta?.code != 200) {
        if (response.meta?.validations != null &&
            response.meta!.validations!.isNotEmpty) {
          AppWidget.openSnackbar(
            'Oops! Something went wrong.',
            response.meta!.validations!.first.message!.first,
          );
          return;
        }

        AppWidget.openSnackbar(
          'Oops! Something went wrong.',
          response.meta?.messages?.first ??
              'Could not update profile. Please try again later.',
        );
        return;
      }

      homeController.user.value = User.fromJson(response.data!);
      homeController.user.refresh();

      // Update user data in local storage
      await localRepository.put(
        LocalRepositoryKey.USER,
        jsonEncode(homeController.user.value.toJson()),
      );

      Get.back();
      AppWidget.openSnackbar(
        'Success',
        'Profile updated successfully.',
        type: SnackBarStatus.success,
      );
    } catch (e) {
      AppWidget.openSnackbar(
        'Oops! Something went wrong.',
        'Could not update profile. Please try again later.',
      );
    } finally {
      showLoading(false);
    }
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
}
