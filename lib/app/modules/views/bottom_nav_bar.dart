import 'package:bravo/app/constants/app_colors/app_colors.dart';
import 'package:bravo/app/modules/views/add_event_screen.dart';
import 'package:bravo/app/modules/views/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/bottom_nav_bar_controller.dart';
import 'calendar_screen.dart';
import 'chat_list_view.dart';
import 'notifications_screen.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final BottomNavBarController controller = Get.put(BottomNavBarController());

    final List<Widget> screens = [
      ChatListView(),
      CalendarScreen(),
      AddEventScreen(),
      NotificationsScreen(),
      ProfileScreen(),
    ];

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // ✅ Keeps the status bar transparent
        statusBarIconBrightness: Brightness.light, // ✅ White icons on dark backgrounds
        statusBarBrightness: Brightness.dark, // ✅ Ensures compatibility on iOS
      ),
    );
    return Scaffold(
      backgroundColor: AppColors.calendarColor,
      body: Obx(() => screens[controller.selectedIndex.value]),
      bottomNavigationBar: Obx(
            () => BottomAppBar(
          color: AppColors.calendarColor,
          elevation: 0,
          child: SizedBox( // Use SizedBox to control height
            height: 80, // Adjust height as needed
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.message, "Messages", 0, controller),
                _buildNavItem(Icons.calendar_month_sharp, "Calendar", 1, controller),
                // Use a Stack to position the add button in the center
                Stack(
                  alignment: Alignment.center,
                  children: [
                    _buildAddButton(controller),
                  ],
                ),
                _buildNavItem(Icons.notifications_active, "Notifications", 3, controller),
                _buildNavItem(Icons.person_3, "Profile", 4, controller),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index, BottomNavBarController controller) {
    bool isSelected = controller.selectedIndex.value == index;
    return InkWell( // Use InkWell for tap functionality
      onTap: () => controller.selectedIndex.value = index,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.white : Colors.grey, // Highlight selected icon
            size: 28, // Adjust icon size
          ),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey, // Highlight selected text
              fontSize: 12, // Adjust font size
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(BottomNavBarController controller) {
    return InkWell(
      onTap: () {
        controller.selectedIndex.value = 2; // Select Profile screen (index 3)
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: controller.selectedIndex.value == 2?AppColors.white:Colors.grey,
        ),
        child: Icon(
          Icons.add,
          color: controller.selectedIndex.value == 2?AppColors.calendarColor:Colors.white,
          size: 32,
        ),
      ),
    );
  }
}
