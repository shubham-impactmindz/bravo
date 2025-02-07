import 'package:bravo/app/constants/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/bottom_nav_bar_controller.dart';
import '../routes/app_pages.dart';

class ChatListView extends StatelessWidget {
  ChatListView({super.key});

  final List<Map<String, dynamic>> chats = [
    {"name": "10 Std Class A", "message": "okay sure!!", "isGroup": true, "time": "12:25 PM"},
    {"name": "10 Std Class B", "message": "okay sure!!", "isGroup": true, "time": "12:25 PM"},
    {"name": "8 Std Class A", "message": "okay sure!!", "isGroup": true, "time": "12:25 PM"},
    {"name": "Kaushik", "message": "okay sure!!", "isGroup": false, "time": "12:25 PM"},
    {"name": "Dad", "message": "okay sure!!", "isGroup": false, "time": "12:25 PM"},
    {"name": "Dad", "message": "okay sure!!", "isGroup": false, "time": "12:25 PM"},
    {"name": "10 Std Class A", "message": "okay sure!!", "isGroup": true, "time": "12:25 PM"},
    {"name": "10 Std Class B", "message": "okay sure!!", "isGroup": true, "time": "12:25 PM"},
    {"name": "8 Std Class A", "message": "okay sure!!", "isGroup": true, "time": "12:25 PM"},
    {"name": "Kaushik", "message": "okay sure!!", "isGroup": false, "time": "12:25 PM"},
    {"name": "Dad", "message": "okay sure!!", "isGroup": false, "time": "12:25 PM"},
    {"name": "Dad", "message": "okay sure!!", "isGroup": false, "time": "12:25 PM"},
  ];

  final controllerBottom = Get.put(BottomNavBarController());

  @override
  Widget build(BuildContext context) {

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.calendarColor,
      body: SafeArea(
        child: Column(
          children: [

            SizedBox(height: screenHeight*0.07,),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Welcome back, Jaini",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500,color: Colors.white),
                  ),
                  GestureDetector(
                    onTap: (){
                      controllerBottom.selectedIndex.value=2;
                    },
                    child: Image.asset('assets/images/add.png',height: 30,),),
                ],
              ),
            ),

            SizedBox(height: screenHeight*0.02), // Small spacing after the header

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.white),
                  suffixIcon: const Icon(Icons.search,color: Colors.white,),
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
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.002),
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
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    final chat = chats[index];
                    return GestureDetector(
                      onTap: (){
                        Get.toNamed(Routes.chatDetail);
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey[700],
                          radius: 24,
                          child: chat["isGroup"]
                              ? Stack(
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
                                  child: const Text("+50", style: TextStyle(fontSize: 10,color: Colors.white)),
                                ),
                              ),
                            ],
                          )
                              : const CircleAvatar(
                            radius: 24,
                            backgroundImage: AssetImage("assets/images/user.png"),
                          ),
                        ),
                        title: Text(chat["name"], style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(chat["message"], style: const TextStyle(color: Colors.grey)),
                        trailing: Text(chat["time"], style: const TextStyle(color: Colors.grey)),
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
