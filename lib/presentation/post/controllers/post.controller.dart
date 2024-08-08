import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/dto/google_book_search.response.dart';
import '../../../data/models/book.model.dart';
import '../../../domain/case/book/post.case.dart';
import '../../../domain/case/book/search_google.case.dart';
import '../../../infrastructure/theme/app.color.dart';
import '../../../infrastructure/theme/app.widget.dart';
import '../../controller.dart.dart';

class PostController extends BaseController {
  TextEditingController titleController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController genreController = TextEditingController();
  TextEditingController synopsisController = TextEditingController();

  Rx<String?> selectedImage = Rx<String?>(null);
  Rx<Items?> selectedBook = Rx<Items?>(null);
  Rx<String?> errorSynopsis = Rx<String?>(null);
  Rx<String?> errorGenre = Rx<String?>(null);

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
    authorController.dispose();
    genreController.dispose();
    synopsisController.dispose();
    super.onClose();
  }

  Future<List<Items>?> searchBooks() async {
    if (selectedBook.value != null) {
      selectedBook.value = null;

      authorController.clear();
      genreController.clear();
      synopsisController.clear();
    }

    String query = '';
    if (titleController.text.isNotEmpty) {
      query += 'intitle:${titleController.text.replaceAll(
            RegExp('\\s+'),
            ' ',
          ).replaceAll(
            ' ',
            '+',
          )}';
    }

    try {
      final result = await SearchGoogleCase().call(query);
      return result.items;
    } catch (e) {
      AppWidget.openSnackbar(
        'Oops! Something went wrong.',
        'Could not find any books. Please try again.',
      );
    }
    return null;
  }

  Future<void> post() async {
    if (selectedBook.value == null) {
      AppWidget.openSnackbar(
        'Oops! Something went wrong.',
        'Please select a book first.',
      );
      return;
    }

    if (genreController.text.isEmpty) {
      errorGenre.value = 'Please enter the genre.';
      return;
    }

    if (synopsisController.text.isEmpty) {
      errorSynopsis.value = 'Please enter the synopsis.';
      return;
    }

    showLoading(true);
    try {
      final response = await PostBookCase().call(
        FormData.fromMap(
          {
            'book_api_id': selectedBook.value!.value!.id!,
            'api_link': selectedBook.value!.value!.selfLink!,
            'title': selectedBook.value!.value!.volumeInfo!.title!,
            'author[]': selectedBook.value!.value?.volumeInfo?.authors != null
                ? selectedBook.value!.value!.volumeInfo!.authors
                : authorController.text.split(','),
            'genre[]': selectedBook.value!.value?.volumeInfo?.categories != null
                ? selectedBook.value!.value!.volumeInfo!.categories
                : genreController.text.split(','),
            'synopsis': selectedBook.value!.value?.volumeInfo?.description ??
                synopsisController.text,
            'average_rating':
                selectedBook.value!.value?.volumeInfo?.averageRating,
            'rating_count': selectedBook.value!.value?.volumeInfo?.ratingsCount,
            'image': selectedImage.value != null
                ? await MultipartFile.fromFile(
                    selectedImage.value!,
                  )
                : null,
            'image_link':
                selectedBook.value!.value?.volumeInfo?.imageLinks?.thumbnail,
            'status': BookStatus.available.index,
          },
        ),
      );

      if (response.meta?.code != 200) {
        if (response.meta?.code == 422) {
          if (response.meta?.validations != null &&
              response.meta!.validations!.isNotEmpty) {
            AppWidget.openSnackbar(
              'Oops! Something went wrong.',
              response.meta!.validations!.first.message!.first,
            );
          }
        } else {
          AppWidget.openSnackbar(
            'Oops! Something went wrong.',
            response.meta?.messages?.first ??
                'Could not post book. Please try again later.',
          );
        }
      } else {
        Get.back();
        AppWidget.openSnackbar(
          'Success!',
          'Book has been posted successfully.',
          type: SnackBarStatus.success,
        );
      }
    } catch (e) {
      AppWidget.openSnackbar(
        'Oops! Something went wrong.',
        'Could not post book. Please try again.',
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

  Future<void> showImage() async {
    if (selectedImage.value != null) {
      await showImageViewer(
        Get.context!,
        FileImage(
          File(selectedImage.value!),
        ),
        backgroundColor: Colors.transparent,
        closeButtonColor: AppColor.primaryColor,
        swipeDismissible: true,
        doubleTapZoomable: true,
        useSafeArea: true,
      );
    }

    if (selectedBook.value != null) {
      await showImageViewer(
        Get.context!,
        NetworkImage(
          selectedBook.value!.value!.volumeInfo!.imageLinks!.thumbnail!,
        ),
        backgroundColor: Colors.transparent,
        closeButtonColor: AppColor.primaryColor,
        swipeDismissible: true,
        doubleTapZoomable: true,
        useSafeArea: true,
      );
    }
  }
}
