import 'package:bravo/app/modules/models/student_detail_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bravo/app/constants/app_colors/app_colors.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/chat_controller.dart';

class StudentDetailScreen extends StatelessWidget {
  StudentDetailScreen({super.key});

  final ChatController controller = Get.put(ChatController());

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
      backgroundColor: AppColors.calendarColor,
      body: SafeArea(
        child: Obx(()=>
            Stack(
              children: [
                Column(
                children: [
                  SizedBox(height: screenHeight * 0.02),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

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
                            CircleAvatar(
                              child: CachedNetworkImage(
                                imageUrl: controller.user.value?.participants?[0].profilePicture??'',
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
                                  String? initials = (controller.user.value?.participants?[0].name?.isNotEmpty ?? false) ? controller.user.value?.participants![0].name![0].toUpperCase() : '?';

                                  return CircleAvatar(
                                    radius: 24,
                                    backgroundColor: AppColors.white, // Red background
                                    child: Text(
                                      initials??'',
                                      style: const TextStyle(
                                        color: AppColors.calendarColor, // White text for contrast
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(width: 20,),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.user.value?.participants?[0].name??'',
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

                        Visibility(
                          visible: false,
                          child: Row(
                            children: [
                              Icon(Icons.arrow_forward_ios,color: Colors.white,size: 20,),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight*0.02,),
                  Expanded( // Key change: Wrap the cards in an Expanded widget
                    child: RefreshIndicator(
                      onRefresh: controller.chatType.value=="private"?controller.fetchUserDetailById:controller.fetchUserDetail,
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
                        child: LayoutBuilder( // Use LayoutBuilder to get the available height
                            builder: (BuildContext context, BoxConstraints constraints) {
                              return SingleChildScrollView( // Needed for content that might overflow the card
                                child: ConstrainedBox( // Constrain the content to at least fill the available height
                                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0), // Add padding around the content
                                    child: Column(
                                      children: [
                                        SizedBox(height: screenHeight * 0.02),
                                        _buildProfileCard(screenHeight, screenWidth), // Extract profile card
                                        SizedBox(height: screenHeight * 0.02),
                                        ListView.builder(
                                          shrinkWrap: true, // Fixes height issue
                                          physics: NeverScrollableScrollPhysics(), // Prevents nested scrolling conflict
                                          itemCount: controller.user.value?.participants?[0].familyRelationships?.length??0,
                                          padding: EdgeInsets.all(5),
                                          itemBuilder: (context, index) {
                                            var familyRelationship = controller.user.value?.participants?[0].familyRelationships?[index];
                                            return _buildSettingsCard(screenHeight, screenWidth, familyRelationship);
                                          },
                                        )

                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                        ),
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
      ),
    );
  }



  Widget _buildProfileCard(double screenHeight, double screenWidth) {
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
      child: Padding( // Add padding here for consistency
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Student Details',style: TextStyle(color: AppColors.popUpColor,fontWeight: FontWeight.w500, fontSize: 14),),
            SizedBox(height: screenHeight*0.01,),
            _buildProfileField("Name", controller.user.value?.participants?[0].firstName??'N/A'),
            _buildProfileField("Surname", controller.user.value?.participants?[0].lastName??'N/A'),
            _buildProfileField("Email", controller.user.value?.participants?[0].email??'N/A'),
            _buildProfileField("Contact No", controller.user.value?.participants?[0].phone??'N/A'),
            _buildProfileField("Group", controller.user.value?.participants?[0].name??'N/A'),
            _buildProfileField("Address", controller.user.value?.participants?[0].address??'N/A'),
            _buildProfileField("City", controller.user.value?.participants?[0].suburb??'N/A'),
            _buildProfileField("Post Code", controller.user.value?.participants?[0].postalCode??'N/A'),
            _buildProfileField("State", controller.user.value?.participants?[0].state??'N/A'),
            _buildProfileField("Country", controller.user.value?.participants?[0].country??'N/A'),
            _buildProfileField("Notes", "N/A"),
          ],
        ),
      ),
    );
  }



  Widget _buildSettingsCard(double screenHeight, double screenWidth, FamilyRelationship? familyRelationship) {
    return Container(
      margin: EdgeInsets.only(top: 10),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Relatives Parties',style: TextStyle(color: AppColors.popUpColor,fontWeight: FontWeight.w500, fontSize: 14),),
            SizedBox(height: screenHeight*0.01,),
            _buildProfileField("Related 1", familyRelationship?.relativeName??'N/A'),
            _buildProfileField("Email", familyRelationship?.email??'N/A'),
            _buildProfileField("Contact No", familyRelationship?.phone??'N/A'),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileField(String? label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label??'N/A',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border(top: BorderSide(color: AppColors.otpBorderColor, width: .5),
                      left: BorderSide(color: AppColors.otpBorderColor, width: .5),
                      right: BorderSide(color: AppColors.otpBorderColor, width: .5),
                      bottom: BorderSide(color: AppColors.otpBorderColor, width: .5))
              ),
              child: Text(
                value,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}