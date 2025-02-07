import 'package:bravo/app/constants/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/bottom_nav_bar_controller.dart';
import '../models/notification_model.dart';

class NotificationsScreen extends StatelessWidget {
  NotificationsScreen({super.key});

  // Sample data for notifications
  final List<NotificationModel> notifications = [
    NotificationModel(
      name: "Adnan Safi",
      message: "Started following you",
      time: "5 min ago",
      avatar: "assets/images/user.png",
    ),
    NotificationModel(
      name: "Joan Baker",
      message: "Invite A virtual Evening of Smooth Jazz",
      time: "20 min ago",
      avatar: "assets/images/user.png",
    ),
    NotificationModel(
      name: "Ronald C. Kinch",
      message: "Like your events",
      time: "1 hr ago",
      avatar: "assets/images/user.png",
    ),
    NotificationModel(
      name: "Clara Tolson",
      message: "Join your Event Gala Music Festival",
      time: "9 hr ago",
      avatar: "assets/images/user.png",
    ),
    NotificationModel(
      name: "Jennifer Fritz",
      message: "Invite you International Kids Safe",
      time: "Tue, 5:10 pm",
      avatar: "assets/images/user.png",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.calendarColor,
      body: SafeArea(
        child: Column(
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
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return ListTile(
                      minTileHeight: 80,
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(notification.avatar),
                        radius: 24,
                      ),
                      title: RichText(
                        text: TextSpan(
                          text: "${notification.name} ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: notification.message,
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                      trailing: Text(
                        notification.time,
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
