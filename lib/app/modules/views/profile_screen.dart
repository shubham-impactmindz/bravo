import 'package:bravo/app/modules/controllers/profile_controller.dart';
import 'package:bravo/app/modules/routes/app_pages.dart';
import 'package:bravo/app/modules/views/webview_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bravo/app/constants/app_colors/app_colors.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final ProfileController controller = Get.put(ProfileController());

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
              () =>Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(height: screenHeight * 0.05),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "My Profile",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            await controller.fetchUserData();
                          },
                          child: Container(
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
                            child: SingleChildScrollView(
                              physics: AlwaysScrollableScrollPhysics(),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    SizedBox(height: screenHeight * 0.02),
                                    Obx(()=>
                                        Row(
                                        children: [
                                          GestureDetector(
                                            onTap: (){
                                              controller.pickFileOrImage();
                                            },
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                CircleAvatar(
                                                  radius:35,
                                                  child: CachedNetworkImage(
                                                    imageUrl: controller.user.value?.userInfo?.profilePicture??"",
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
                                                      String? initials = (controller.user.value?.userInfo?.fullname?.isNotEmpty ?? false) ? controller.user.value?.userInfo?.fullname![0].toUpperCase() : '?';

                                                      return CircleAvatar(
                                                        radius: 35,
                                                        backgroundColor: AppColors.calendarColor, // Red background
                                                        child: Text(
                                                          initials??'',
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
                                                Positioned(
                                                  bottom: 0,
                                                  right: 0,
                                                  child: CircleAvatar(
                                                    radius: 10,
                                                    backgroundColor: Colors.black54,
                                                    child: Icon(Icons.edit,color: Colors.white,size: 10,),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 12),
                                          Text(
                                            controller.user.value?.userInfo?.fullname ?? "", // Dynamic name
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.02),
                                    _buildProfileCard(controller),
                                    SizedBox(height: screenHeight * 0.02),
                                    _buildSettingsCard(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  controller.isLoading.value ? Container(
                    color: Colors.black.withOpacity(0.2),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ) : Container()
                ],
              ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(ProfileController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildProfileField("Email", controller.user.value?.userInfo?.email ?? "N/A"),
            _buildProfileField("Contact No", controller.user.value?.userInfo?.phone ?? "N/A"),
            _buildProfileField("Address", controller.user.value?.userInfo?.address ?? "N/A"),
            _buildProfileField("Role", controller.user.value?.userInfo?.role ?? "N/A"),
            _buildProfileField("Authentication Code", controller.user.value?.userInfo?.authrizationCode ?? "N/A"),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildListTile('assets/images/about.png', "About Bravo"),
          _buildListTile('assets/images/privacy.png', "Privacy Policy"),
          _buildListTile('assets/images/logout.png', "Sign out",
              subtitle: "Further secure your account for safety"),
        ],
      ),
    );
  }

  Widget _buildProfileField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.otpBorderColor, width: 0.5),
              ),
              child: Text(
                value=="null"|| value==""? 'N/A' :value,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(String icon, String title, {String? subtitle}) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey[200],
        child: Image.asset(icon),
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      subtitle: subtitle != null
          ? Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey))
          : null,
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () async {
        if (title == "Sign out") {
          _showSignOutDialog();
        }
        if (title == "About Bravo") {
          Get.toNamed(Routes.about);
        }
        if (title == "Privacy Policy") {
          Get.toNamed(Routes.webView);
        }
      },
    );
  }

  void _showSignOutDialog() {
    Get.defaultDialog(
      title: "Sign Out",
      middleText: "Are you sure you want to sign out?",
      textConfirm: "Yes",
      textCancel: "No",
      confirmTextColor: Colors.white,
      onConfirm: () async {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.clear();
        Get.offAllNamed(Routes.uniqueCode);
      },
    );
  }
}
