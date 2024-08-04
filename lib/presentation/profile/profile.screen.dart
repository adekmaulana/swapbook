import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../infrastructure/theme/app.color.dart';
import '../../infrastructure/theme/app.widget.dart';
import '../home/wrapper.home.screen.dart';
import 'controllers/profile.controller.dart';
import 'profile.appbar.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return WrapperHomeScreen(
      backgroundImage: 'assets/images/background-search.png',
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        body: controller.obx(
          (state) {
            return CustomScrollView(
              physics: const ClampingScrollPhysics(),
              slivers: [
                SliverPersistentHeader(
                  delegate: ProfileAppBar(),
                  pinned: true,
                  floating: true,
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 20),
                ),
                SliverFillRemaining(
                  child: Container(color: Colors.transparent),
                ),
              ],
            );
          },
          onLoading: Center(
            child: AppWidget.getLoadingIndicator(
              color: AppColor.primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
