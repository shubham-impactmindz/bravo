import 'package:bravo/app/modules/controllers/chat_individual_controller.dart';
import 'package:bravo/app/modules/views/chat_detail_individual_screen.dart';
import 'package:bravo/app/modules/views/student_detail_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bravo/app/constants/app_colors/app_colors.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/chat_controller.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final ChatController controller = Get.put(ChatController());
  final ChatIndividualController individualController = Get.put(ChatIndividualController());

  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId');
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.calendarColor,
      body: SafeArea(
        child: Obx(() {
          if (controller.chats.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final chat = controller.chats[0];

          return Column(
            children: [
              SizedBox(height: screenHeight * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Image.asset(
                          'assets/images/back.png',
                          height: 30,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.grey[300],
                            child: CachedNetworkImage(
                              imageUrl: chat.profilePic ?? "",
                              imageBuilder: (context, imageProvider) => Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) => const CircularProgressIndicator(),
                              errorWidget: (context, url, error) {
                                String initials = chat.name?.isNotEmpty == true
                                    ? chat.name![0].toUpperCase()
                                    : '?';

                                return CircleAvatar(
                                  radius: 24,
                                  backgroundColor: AppColors.calendarColor,
                                  child: Text(
                                    initials,
                                    style: const TextStyle(
                                      color: AppColors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            chat.name ?? "",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Visibility(
                    visible: false,
                    child: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: chat.groupMembers?.length ?? 0,
                    itemBuilder: (context, index) {
                      final group = chat.groupMembers![index];
                      if (group.roleId == "5") return Container();

                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey, width: 0.5),
                          ),
                        ),
                        child: ListTile(
                          onTap: () {
                            controller.userId.value = group.userId ?? "";
                            controller.fetchUserDetail();
                            controller.update();
                            Get.to(() => StudentDetailScreen());
                          },
                          minTileHeight: 80,
                          leading: CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.grey[300],
                            child: CachedNetworkImage(
                              imageUrl: group.profilePic ?? "",
                              imageBuilder: (context, imageProvider) => Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) => const CircularProgressIndicator(),
                              errorWidget: (context, url, error) {
                                String initials = group.name?.isNotEmpty == true
                                    ? group.name![0].toUpperCase()
                                    : '?';
                                return CircleAvatar(
                                  radius: 24,
                                  backgroundColor: AppColors.calendarColor,
                                  child: Text(
                                    initials,
                                    style: const TextStyle(
                                      color: AppColors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          title: Text(
                            group.name ?? "",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  individualController.chatId.value =
                                      int.tryParse(group.userId ?? "") ?? 0;
                                  individualController.chatType.value = "private";
                                  individualController.onInit();
                                  individualController.update();
                                  Get.to(() => ChatDetailIndividualScreen());
                                },
                                child: group.userId == userId
                                    ? Text('YOU',style: TextStyle(fontSize: 15),)
                                    : Image.asset(
                                  'assets/images/messenger.png',
                                  height: 23,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Icon(Icons.arrow_forward_ios, size: 15),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
