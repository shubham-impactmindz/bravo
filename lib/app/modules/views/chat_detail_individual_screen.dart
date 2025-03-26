import 'dart:io';

import 'package:bravo/app/constants/app_colors/app_colors.dart';
import 'package:bravo/app/modules/controllers/chat_individual_controller.dart';
import 'package:bravo/app/modules/routes/app_pages.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../widgets/event_card.dart';
import '../controllers/profile_controller.dart';
import '../models/user_chat_model.dart';
import 'file_preview_doc_screen.dart';
import 'file_preview_screen.dart';

class ChatDetailIndividualScreen extends StatelessWidget {
  ChatDetailIndividualScreen({super.key});

  final ChatIndividualController controller = Get.put(ChatIndividualController());

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // ✅ Keeps the status bar transparent
        statusBarIconBrightness: Brightness.light, // ✅ White icons on dark backgrounds
        statusBarBrightness: Brightness.dark, // ✅ Ensures compatibility on iOS
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.calendarColor, // Match background color
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: screenHeight * 0.02),
                Obx(
                  () => Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Image.asset(
                          'assets/images/back.png',
                          height: 30,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius:24,
                            child: CachedNetworkImage(
                              imageUrl: controller.chats[0].profilePic ?? '',
                              imageBuilder: (context, imageProvider) => Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle, // Ensures circular shape
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) => const CircularProgressIndicator(),
                              errorWidget: (context, url, error) {
                                String initials = (controller.chats.isNotEmpty ?? false) ? controller.chats[0].name![0].toUpperCase() : '?';

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
                          controller.chats[0].chatType == "group"
                              ? Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: CircleAvatar(
                                    radius: 10,
                                    backgroundColor: Colors.black54,
                                    child: Text(
                                        (controller.chats[0].groupMembers?.length
                                                .toString()) ??
                                            "0",
                                        style: TextStyle(
                                            fontSize: 10, color: Colors.white)),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          if(controller.chatType.value=="private"){
                            controller.userId.value = controller.chats[0].userId??'';
                            controller.fetchUserDetailById();
                            controller.update();
                            Get.toNamed(Routes.studentDetail);
                          } else {
                            Get.toNamed(Routes.studentList);
                          }
                        },
                        child: Obx(()=>
                            Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.chats[0].name ?? "",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              controller.chats[0].chatType == "group"
                                  ? SizedBox(
                                width: screenWidth*0.50,
                                      child: Text(
                                        controller.chats[0].groupMembers
                                                ?.map((member) => member.name)
                                                .join(", ") ??
                                            "",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.white),
                                        maxLines: 1,
                                        overflow: TextOverflow
                                            .ellipsis, // Ensures single-line truncation
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: RefreshIndicator(
                      onRefresh: controller.fetchUserChats,
                      child: Obx(
                        () {

                          if ((controller.chats[0].allMessages??[]).isEmpty) {
                            return const Center(child: Text("No chats available"));
                          }

                          return ListView.builder(
                            controller: controller.scrollController,
                            reverse: false, // Display items bottom-to-top
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: controller.chats[0].allMessages?.length ?? 0,
                            padding: EdgeInsets.all(5),
                            itemBuilder: (context, index) {
                              var message = controller.chats[0].allMessages?[index];
                              return _buildMessageBubble(message??AllMessage(), context);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
                _buildMessageInputArea(),
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

  Widget _buildMessageBubble(AllMessage message, BuildContext context) {
    int messageIndex = controller.chats
        .indexWhere((chat) => chat.allMessages!.contains(message));

    final ProfileController profileController = Get.put(ProfileController());
    bool isMe =
        message.senderId == profileController.user.value?.userInfo?.userId;
    bool isLastMessage = true;

    if (controller.chats[messageIndex].allMessages != null) {
      List<AllMessage> currentChatMessages =
          controller.chats[messageIndex].allMessages!;
      int currentMessageIndex = currentChatMessages.indexOf(message);

      if (currentMessageIndex < currentChatMessages.length - 1) {
        AllMessage nextMessage = currentChatMessages[currentMessageIndex + 1];
        isLastMessage = message.senderId != nextMessage.senderId;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe && isLastMessage && message.messageType != "event")
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: CircleAvatar(
                radius: 15,
                child: CachedNetworkImage(
                  imageUrl: message.senderProfile ?? "",
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, // Ensures circular shape
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => const CircularProgressIndicator(),
                  errorWidget: (context, url, error) {
                    String initials = (message.senderName?.isNotEmpty ?? false) ? message.senderName![0].toUpperCase() : '?';

                    return CircleAvatar(
                      radius: 15,
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
            )
          else if (!isMe && message.messageType != "event")
            const SizedBox(width: 38), // 15 (radius) * 2 + 8 (margin)

          if (!isMe && isLastMessage && message.messageType != "event")
            const SizedBox(width: 8),

          Expanded(
            child: message.messageType != "event"
                ? Column(
                    crossAxisAlignment: isMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isMe
                              ? AppColors.popUpColor.withOpacity(0.9)
                              : AppColors.calendarColor.withOpacity(0.9),
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(20),
                            topRight: const Radius.circular(20),
                            bottomLeft: isMe
                                ? const Radius.circular(20)
                                : const Radius.circular(5),
                            bottomRight: isMe
                                ? const Radius.circular(5)
                                : const Radius.circular(20),
                          ),
                        ),
                        child: message.messageType == "text"
                            ? Text(
                                message.messageText ?? "",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: isMe ? Colors.white : AppColors.white,
                                ),
                              )
                            : GestureDetector(
                                onTap: () async {
                                  try {
                                    String fileUrl = message.messageText ?? "";
                                    String fileName = fileUrl.split('/').last;
                                    Get.dialog(
                                      Center(
                                          child:
                                              CircularProgressIndicator()), // Show loading
                                      barrierDismissible: false,
                                    );

                                    final directory =
                                        await getApplicationDocumentsDirectory();
                                    final filePath =
                                        '${directory.path}/$fileName';

                                    await Dio().download(fileUrl, filePath);

                                    Get.back(); // Close loading indicator

                                    // Determine file type and open accordingly
                                    if (fileUrl.endsWith('.png') ||
                                        fileUrl.endsWith('.jpg') ||
                                        fileUrl.endsWith('.jpeg') ||
                                        fileUrl.endsWith('.gif')) {
                                      Get.dialog(Dialog(
                                          child: Image.file(File(filePath))));
                                    } else if (fileUrl.endsWith('.pdf')) {
                                      Get.to(() => FilePreviewScreen(
                                          filePath: filePath));
                                    } else if (fileUrl.endsWith('.doc') ||
                                        fileUrl.endsWith('.docx')) {
                                      Get.to(() => FilePreviewDocScreen(filePath: fileUrl));
                                    } else {
                                      Get.snackbar("File Type",
                                          "Cannot preview this file type.");
                                    }
                                  } catch (e) {
                                    Get.back(); // Close loading indicator in case of error
                                    Get.snackbar(
                                        "Error", "An error occurred: $e");
                                  }
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'File Tap To View',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: isMe
                                              ? Colors.white
                                              : AppColors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      getMessageText(message.messageText?.split('/').last ??
                                          ""),
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: isMe
                                            ? Colors.white
                                            : AppColors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                      if (isLastMessage && message.messageType != "event")
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (!isMe)
                                Text(
                                  message.senderName ?? "Unknown",
                                  style: const TextStyle(
                                      color: AppColors.textLightColor,
                                      fontSize: 12),
                                ),
                              const SizedBox(width: 5),
                              Text(
                                _formatTime(message.timestamp.toString(),message.deviceTime),
                                style: const TextStyle(
                                    color: AppColors.textLightColor,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                    ],
                  )
                : EventCard(message),
          ),
        ],
      ),
    );
  }

  // Helper function to parse and format time
  String _formatTime(String? timestamp, String? deviceTime) {
    try {
      DateTime now = DateTime.now();

      if (deviceTime != null && deviceTime.isNotEmpty) {
        // Parse device_time correctly
        DateTime deviceDateTime = DateFormat("dd/MM/yyyy hh:mm a").parse(deviceTime);

        if (deviceDateTime.year == now.year &&
            deviceDateTime.month == now.month &&
            deviceDateTime.day == now.day) {
          // If today, return only the time
          return DateFormat('hh:mm a').format(deviceDateTime);
        } else {
          // If not today, return date and time (10/03, 12:35 PM)
          return DateFormat('dd/MM, hh:mm a').format(deviceDateTime);
        }
      } else if (timestamp != null && timestamp.isNotEmpty) {
        // Parse timestamp correctly
        DateTime timestampDateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(timestamp);
        return DateFormat('dd/MM/yyyy hh:mm a').format(timestampDateTime);
      }
    } catch (e) {
      print("Error parsing date: $e");
    }
    return "Invalid date"; // Fallback for errors
  }


  String getMessageText(String message) {

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

  Widget _buildMessageInputArea() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border(
                top: BorderSide(
                    color: AppColors.borderColor.withOpacity(.2), width: 0.61),
                bottom: BorderSide(
                    color: AppColors.borderColor.withOpacity(.2), width: 0.61),
                right: BorderSide(
                    color: AppColors.borderColor.withOpacity(.2), width: 0.61),
                left: BorderSide(
                    color: AppColors.borderColor.withOpacity(.2),
                    width: 0.61))),
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                controller.pickFileOrImage();
              },
              child: Image.asset(
                'assets/images/select.png',
                height: 30,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: controller.messageController,
                style: const TextStyle(
                    color: AppColors.textDarkColor), // White text in input
                decoration: InputDecoration(
                  hintText: 'Type Message',
                  hintStyle: const TextStyle(color: Colors.grey),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(25.7),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(25.7),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              icon: Image.asset(
                'assets/images/send_message.png',
                height: 30,
              ), // White send icon
              onPressed: () async {
                await controller.sendUserMessage(
                    messageTypeId: "1", parentMessageId: "");
              },
            ),
          ],
        ),
      ),
    );
  }
}
