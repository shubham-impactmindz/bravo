import 'package:bravo/app/modules/controllers/all_user_controller.dart';
import 'package:bravo/app/modules/controllers/chat_individual_controller.dart';
import 'package:bravo/app/modules/views/chat_detail_individual_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bravo/app/constants/app_colors/app_colors.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllUserListScreen extends StatelessWidget {
  AllUserListScreen({super.key});

  final ChatIndividualController individualController = Get.put(ChatIndividualController());
  final AllUserController controller = Get.put(AllUserController());
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    return FutureBuilder<SharedPreferences>(
      future: _prefs,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            backgroundColor: AppColors.calendarColor,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final userId = snapshot.data?.getString('userId')??"";

        return Scaffold(
          backgroundColor: AppColors.calendarColor,
          body: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    SizedBox(height: screenHeight * 0.02),
                    _buildAppBar(),
                    SizedBox(height: screenHeight * 0.02),
                    _buildUserList(userId, screenWidth),
                  ],
                ),
                Obx(() => controller.isLoading.value
                    ? Container(
                  color: Colors.black.withOpacity(0.2),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
                    : const SizedBox.shrink()),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppBar() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
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
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Users',
                    style: TextStyle(
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
            child: Row(
              children: [
                Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserList(String? userId, double screenWidth) {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Obx(() {
          final users = controller.user.value?.allUsers ?? [];
          if (users.isEmpty) {
            return const Center(child: Text("No User Found"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              if (user.roleId == "5") return const SizedBox.shrink();

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey, width: 0.5),
                  ),
                ),
                child: ListTile(
                  minTileHeight: 80,
                  leading: _buildUserAvatar(user),
                  title: Text(
                    "${user.firstName ?? ""} ${user.lastName ?? ""}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  trailing: userId == user.userId
                      ? Text('YOU',style: TextStyle(fontSize: 15),)
                      : GestureDetector(
                    onTap: () => _navigateToChat(user),
                    child: SizedBox(
                      width: screenWidth * 0.06,
                      child: Image.asset(
                        'assets/images/messenger.png',
                        height: 23,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  Widget _buildUserAvatar(dynamic user) {
    return CircleAvatar(
      radius: 24,
      backgroundColor: Colors.grey[300],
      child: CachedNetworkImage(
        imageUrl: user.profilePicture ?? "",
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
          final initials = (user.firstName?.isNotEmpty ?? false)
              ? user.firstName![0].toUpperCase()
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
    );
  }

  void _navigateToChat(dynamic user) {
    individualController.chatId.value = int.tryParse(user.userId ?? "") ?? 0;
    individualController.chatType.value = "private";
    individualController.onInit();
    individualController.update();
    Get.to(() => ChatDetailIndividualScreen());
  }
}