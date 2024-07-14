import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../infrastructure/theme/app.color.dart';
import '../../infrastructure/theme/app.widget.dart';
import 'controllers/chat_find.controller.dart';

class ChatFindScreen extends GetView<ChatFindController> {
  const ChatFindScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatFindController>(
      init: controller,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 59.15,
                height: 6,
                decoration: BoxDecoration(
                  color: AppColor.primaryBlackColor,
                  borderRadius: BorderRadius.circular(5.2),
                ),
              ),
              const SizedBox(height: 51),
              // Search Bar
              Column(
                children: [
                  TextField(
                    controller: controller.searchController,
                    onChanged: controller.onSearch,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.search,
                    style: const TextStyle(
                      color: AppColor.primaryBlackColor,
                      fontSize: 13,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'Search',
                      alignLabelWithHint: true,
                      hintStyle: const TextStyle(
                        color: AppColor.secondaryGreyColor,
                        fontSize: 11,
                      ),
                      fillColor: AppColor.backgroundColor,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: AppColor.borderColor,
                          width: 0.83,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: AppColor.borderColor,
                          width: 0.83,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: AppColor.secondaryGreyColor,
                      ),
                      suffixIcon: Obx(
                        () {
                          if (controller.search.value.isNotEmpty) {
                            return IconButton(
                              onPressed: () {
                                controller.searchController.clear();
                                controller.search('');
                              },
                              constraints: const BoxConstraints(),
                              iconSize: 14,
                              icon: const Icon(
                                Icons.close_rounded,
                                color: AppColor.secondaryGreyColor,
                              ),
                            );
                          }

                          return const SizedBox.shrink();
                        },
                      ),
                      suffixIconConstraints: const BoxConstraints(
                        minWidth: 14,
                        minHeight: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: controller.obx(
                  (state) => ListView.separated(
                    itemCount: state!.length,
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 12,
                    ),
                    itemBuilder: (context, index) {
                      final user = state[index];

                      return ListTile(
                        onTap: () async {
                          await controller.createChat(user.id!);
                        },
                        leading: const SizedBox(
                          width: 38,
                          height: 38,
                          child: CircleAvatar(),
                        ),
                        title: Text(
                          user.name!,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    },
                  ),
                  onEmpty: const SizedBox.shrink(),
                  onLoading: AppWidget.getLoadingIndicator(
                    color: AppColor.primaryColor,
                  ),
                  onError: (error) => Center(
                    child: Text(
                      error.toString(),
                      style: const TextStyle(
                        color: AppColor.primaryBlackColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
