import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../infrastructure/theme/app.color.dart';
import 'controllers/home.controller.dart';

class WrapperHomeScreen extends StatefulWidget {
  final String? backgroundImage;
  final Widget child;

  const WrapperHomeScreen({
    super.key,
    this.backgroundImage,
    required this.child,
  });

  @override
  State<WrapperHomeScreen> createState() => _WrapperHomeScreenState();
}

class _WrapperHomeScreenState extends State<WrapperHomeScreen>
    with AutomaticKeepAliveClientMixin<WrapperHomeScreen> {
  @override
  bool get wantKeepAlive {
    return true;
  }

  HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
      decoration: BoxDecoration(
        color: AppColor.backgroundColor,
        image: widget.backgroundImage != null
            ? DecorationImage(
                image: Image.asset(
                  widget.backgroundImage!,
                  scale: 4,
                ).image,
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  AppColor.backgroundColor.withOpacity(
                    0.08,
                  ),
                  BlendMode.hardLight,
                ),
              )
            : null,
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.25),
            blurRadius: 4.35,
            offset: Offset(0, 4.35),
          ),
        ],
      ),
      child: widget.child,
    );
  }
}
