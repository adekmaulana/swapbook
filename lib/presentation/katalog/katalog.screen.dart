import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:swapbook/presentation/home/wrapper.home.screen.dart';

import 'controllers/katalog.controller.dart';

class KatalogScreen extends GetView<KatalogController> {
  const KatalogScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return WrapperHomeScreen(
      backgroundImage: 'assets/images/background-katalog.png',
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Row(
            children: [
              SizedBox(
                child: IconButton(
                  onPressed: () {
                    controller.openDrawer();
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  style: const ButtonStyle(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  iconSize: 24,
                  icon: SvgPicture.asset(
                    'assets/icons/drawer.svg',
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                child: IconButton(
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  style: const ButtonStyle(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  iconSize: 24,
                  icon: SvgPicture.asset(
                    'assets/icons/camera.svg',
                  ),
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                child: Stack(
                  children: [
                    IconButton(
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      style: const ButtonStyle(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      iconSize: 24,
                      icon: SvgPicture.asset(
                        'assets/icons/notification.svg',
                      ),
                    ),
                    Positioned(
                      right: 4,
                      top: 4,
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Color(0xFFDE0639),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          automaticallyImplyLeading: false,
        ),
        body: const Center(
          child: Text(
            'KatalogScreen is working',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
