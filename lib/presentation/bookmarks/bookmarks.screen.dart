import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../../infrastructure/theme/app.color.dart';
import '../home/wrapper.home.screen.dart';
import 'controllers/bookmarks.controller.dart';

class BookmarksScreen extends GetView<BookmarksController> {
  const BookmarksScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return WrapperHomeScreen(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('BookmarksScreen'),
          centerTitle: true,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
            systemNavigationBarColor: AppColor.backgroundColor,
            systemNavigationBarIconBrightness: Brightness.dark,
          ),
        ),
        body: const Center(
          child: Text(
            'BookmarksScreen is working',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
