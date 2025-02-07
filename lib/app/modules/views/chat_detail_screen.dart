import 'package:bravo/app/constants/app_colors/app_colors.dart';
import 'package:bravo/app/modules/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../widgets/event_card.dart';
import '../controllers/chat_controller.dart';

class ChatDetailScreen extends StatelessWidget {
  ChatDetailScreen({super.key});

  final ChatController controller = Get.put(ChatController());
  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.calendarColor, // Match background color
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.02),
            Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: (){
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
                    const CircleAvatar(
                      radius: 24,
                      backgroundImage: AssetImage("assets/images/group.png"),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.black54,
                        child: const Text("+50",
                            style:
                                TextStyle(fontSize: 10, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: (){
                    Get.toNamed(Routes.studentList);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "10th Std Class A",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Pranav Ray, Ayesha, Rossini",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
                child: Obx(
                  () => ListView.builder(
                    itemCount: controller.messages.length + 1,
                    padding: EdgeInsets.all(5),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return EventCard();
                      }
                      var message = controller.messages[index - 1];
                      return _buildMessageBubble(message, context);
                    },
                  ),
                ),
              ),
            ),
            _buildMessageInputArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(
      Map<String, dynamic> message, BuildContext context) {
    int messageIndex = controller.messages.indexOf(message);
    bool isLastMessage = true;
    if (messageIndex < controller.messages.length - 1) {
      var nextMessage = controller.messages[messageIndex + 1];
      isLastMessage = message['sender'] != nextMessage['sender'];
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            message['isMe'] ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          // Use Opacity to maintain spacing even when avatar is not shown
          Opacity(
            opacity: !message['isMe'] && isLastMessage
                ? 1.0
                : 0.0, // Show only on last message
            child: Row(
              // Wrap avatar and SizedBox in a Row
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(message['avatar']),
                  radius: 10,
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),

          Expanded(
            // Use Expanded to fill available space
            child: Column(
              crossAxisAlignment: message['isMe']
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: message['isMe']
                        ? AppColors.popUpColor.withOpacity(0.25)
                        : AppColors.calendarColor.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Text(
                    message['text'],
                    style: const TextStyle(
                        fontSize: 16, color: AppColors.calendarColor),
                  ),
                ),
                if (isLastMessage)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          message['sender'],
                          style: const TextStyle(
                              color: AppColors.textLightColor, fontSize: 12),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          message['time'],
                          style: const TextStyle(
                              color: AppColors.textLightColor, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to parse and format time
  String _formatTime(String timeString) {
    try {
      // Adjust the format string below to match your actual time format
      DateFormat originalFormat = DateFormat(
          "HH:mm:ss"); // Example: If your time is like "2024-07-24 14:30:00"
      DateTime dateTime = originalFormat.parse(timeString);

      return DateFormat('hh:mm a').format(dateTime);
    } catch (e) {
      print("Error parsing date: $e");
      return "Invalid date"; // Or handle the error as needed
    }
  }

  Widget _buildMessageInputArea() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),
            border: Border(top: BorderSide(color: AppColors.borderColor.withOpacity(.2),width: 0.61),
                bottom: BorderSide(color: AppColors.borderColor.withOpacity(.2),width: 0.61),
                right: BorderSide(color: AppColors.borderColor.withOpacity(.2),width: 0.61),
                left: BorderSide(color: AppColors.borderColor.withOpacity(.2),width: 0.61))),
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Image.asset('assets/images/select.png',height: 30,),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: messageController,
                style:
                    const TextStyle(color: AppColors.textDarkColor), // White text in input
                decoration: InputDecoration(
                  hintText: 'Type Message',
                  hintStyle:
                      const TextStyle(color: Colors.grey),
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
              icon:
              Image.asset('assets/images/send_message.png',height: 30,), // White send icon
              onPressed: () {
                controller.sendMessage(messageController.text);
                messageController.clear();
              },
            ),
          ],
        ),
      ),
    );
  }
}
