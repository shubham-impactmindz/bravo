import 'package:bravo/app/constants/app_colors/app_colors.dart';
import 'package:bravo/app/modules/controllers/chat_controller.dart';
import 'package:bravo/app/modules/controllers/message_controller.dart';
import 'package:bravo/app/modules/controllers/profile_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/bottom_nav_bar_controller.dart';
import '../routes/app_pages.dart';

class ChatListView extends StatelessWidget {
  ChatListView({super.key});
  final MessageController controller = Get.put(MessageController());
  final ChatController chatController = Get.put(ChatController());
  final ProfileController profileController = Get.put(ProfileController());

  final controllerBottom = Get.put(BottomNavBarController());

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // ✅ Keeps the status bar transparent
        statusBarIconBrightness: Brightness.light, // ✅ White icons on dark backgrounds
        statusBarBrightness: Brightness.dark, // ✅ Ensures compatibility on iOS
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.calendarColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: screenHeight * 0.07),
                Obx(() => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Welcome back, ${profileController.user.value?.userInfo?.username ?? ""}',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.allUser);
                        },
                        child: Image.asset('assets/images/add.png', height: 30),
                      ),
                    ],
                  ),
                )),

                SizedBox(height: screenHeight * 0.02),

                // ✅ Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextField(
                    controller: controller.searchController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Search...",
                      hintStyle: TextStyle(color: Colors.white),
                      suffixIcon: const Icon(Icons.search, color: Colors.white),
                      filled: true,
                      fillColor: Colors.grey[800],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: RefreshIndicator(
                      onRefresh: controller.fetchUserChats,
                      child: Obx(() {
                        if (controller.filteredChats.isEmpty) {
                          return const Center(child: Text("No chats found"));
                        }

                        return ListView.builder(
                          controller: controller.scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: controller.filteredChats.length + (controller.isMoreLoading.value ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == controller.filteredChats.length) {
                              return const Padding(
                                padding: EdgeInsets.all(10),
                                child: Center(child: CircularProgressIndicator()),
                              );
                            }

                            final chat = controller.filteredChats[index];
                            return GestureDetector(
                              onTap: () async {
                                chatController.chatId.value = chat.chatId ?? 0;
                                chatController.chatType.value = chat.type ?? "";
                                chatController.onInit();
                                chatController.update();
                                Get.toNamed(Routes.chatDetail);
                              },
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 24,
                                  backgroundColor: Colors.grey[300],
                                  child: CachedNetworkImage(
                                    imageUrl: chat.profilePic ?? "",
                                    imageBuilder: (context, imageProvider) => Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                      ),
                                    ),
                                    placeholder: (context, url) => const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) {
                                      String initials = (chat.name?.isNotEmpty ?? false) ? chat.name![0].toUpperCase() : '?';

                                      return CircleAvatar(
                                        radius: 24,
                                        backgroundColor: AppColors.calendarColor, // Red background
                                        child: Text(
                                          initials,
                                          style: const TextStyle(
                                            color: AppColors.white, // White text for contrast
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                title: Text(chat.name ?? "Unknown", style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text(getMessageText(chat.lastMessage?.messageText), style: const TextStyle(color: Colors.grey)),
                              ),
                            );
                          },
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),

            Obx(() {
              return controller.isLoading.value
                  ? Container(
                color: Colors.black.withOpacity(0.2),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
                  : const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }

  String getMessageText(String? message) {
    if (message == null || message.isEmpty) {
      return "No messages";
    }

    String lowerMessage = message.toLowerCase();

    if (lowerMessage.endsWith('.jpg') || lowerMessage.endsWith('.jpeg') || lowerMessage.endsWith('.png') || lowerMessage.endsWith('.gif')) {
      return "You have a new image";
    } else if (lowerMessage.endsWith('.pdf')) {
      return "You have received a PDF";
    } else if (lowerMessage.endsWith('.doc') || lowerMessage.endsWith('.docx')) {
      return "You have received a document";
    } else if (lowerMessage.endsWith('.mp4') || lowerMessage.endsWith('.avi') || lowerMessage.endsWith('.mov')) {
      return "You have received a video";
    } else if (lowerMessage.endsWith('.mp3') || lowerMessage.endsWith('.wav')) {
      return "You have received an audio file";
    } else {
      return message; // If it's a normal text message, display as it is.
    }
  }
}
