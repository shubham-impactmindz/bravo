import 'package:bravo/app/constants/app_colors/app_colors.dart';
import 'package:bravo/app/modules/controllers/notification_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/notification_model.dart';

class NotificationsScreen extends StatelessWidget {
  NotificationsScreen({super.key});

  final NotificationController controller = Get.put(NotificationController());

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
        child: Obx(
          () => Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.05),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Notifications",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await controller.fetchNotificationList();
                      },
                      child: controller.notifications.isEmpty
                          ? Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ListView(
                                physics: AlwaysScrollableScrollPhysics(),
                                children: const [
                                  SizedBox(height: 300), // Ensure scrollable area
                                  Center(child: Text('No Notifications')),
                                ],
                              ),
                            )
                          : Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                            child: ListView.builder(
                                padding: EdgeInsets.all(10),
                                itemCount: controller.notifications.length,
                                itemBuilder: (context, index) {
                                  final notification =
                                      controller.notifications[index];
                                  return Container(
                                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                    decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            CircleAvatar(
                                              radius: 35,
                                              backgroundImage: notification.sender?.profilePicture != null
                                                  ? NetworkImage(notification.sender!.profilePicture!)
                                                  : null,
                                              child: notification.sender?.profilePicture == null
                                                  ? Text(
                                                (notification.sender?.name?.isNotEmpty ?? false)
                                                    ? notification.sender!.name![0].toUpperCase()
                                                    : '?',
                                                style: TextStyle(
                                                  color: AppColors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                                  : null,
                                            ),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: notification.content!.contains('message')
                                                  ? RichText(
                                                text: TextSpan(
                                                  text: "${notification.content} from",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.normal,
                                                    color: Colors.grey[700],
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text: " ${notification.sender?.name} ",
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                                  : RichText(
                                                text: TextSpan(
                                                  text: "${notification.content} created by ",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.normal,
                                                    color: Colors.grey[700],
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text: "${notification.sender?.name} ",
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        Text(
                                          _formatTime(notification.deviceTime??DateTime.now().toIso8601String()),
                                          style: TextStyle(color: Colors.grey, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  );

                                },
                              ),
                          ),
                    ),
                  ),
                ],
              ),
              if (controller.isLoading.value)
                Container(
                  color: Colors.black.withOpacity(0.2),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}


String _formatTime(String? deviceTime) {
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
    }
  } catch (e) {
    print("Error parsing date: $e");
  }
  return "Invalid date"; // Fallback for errors
}
