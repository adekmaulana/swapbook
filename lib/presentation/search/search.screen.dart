import 'package:flutter/material.dart' hide SearchController;
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../../infrastructure/theme/app.color.dart';
import '../home/wrapper.home.screen.dart';
import 'controllers/search.controller.dart';

class SearchScreen extends GetView<SearchController> {
  const SearchScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return WrapperHomeScreen(
      backgroundImage: 'assets/images/background-search.png',
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('SearchScreen'),
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
            'SearchScreen is working',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
