import 'package:bravo/app/modules/controllers/all_user_controller.dart';
import 'package:bravo/app/modules/controllers/chat_individual_controller.dart';
import 'package:bravo/app/modules/routes/app_pages.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bravo/app/constants/app_colors/app_colors.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controllers/chat_controller.dart';

class AllUserListScreen extends StatelessWidget {
  AllUserListScreen({super.key});


  final ChatIndividualController individualController = Get.put(ChatIndividualController());
  final AllUserController controller = Get.put(AllUserController());

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
        child: Stack(
          children: [
            Obx(()=>
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

                            Column(
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
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: (controller.user.value?.allUsers??[]).isNotEmpty?
                      ListView.builder(
                        padding: EdgeInsets.all(10),
                        itemCount: controller.user.value?.allUsers?.length,
                        itemBuilder: (context, index) {
                          final group = controller.user.value?.allUsers?[index];
                          return Container(
                            margin: EdgeInsets.only(left: 10,right: 10),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.grey, width: 0.5),
                              ),
                            ),
                            child: ListTile(
                              minTileHeight: 80,
                              leading: CircleAvatar(
                                radius: 24, // Adjust size as needed
                                backgroundColor: Colors.grey[300], // Placeholder background color
                                child: CachedNetworkImage(
                                  imageUrl: group?.profilePicture ?? "",
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
                                    String initials = (group?.firstName?.isNotEmpty ?? false) ? group!.firstName![0].toUpperCase() : '?';

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
                              title: RichText(
                                text: TextSpan(
                                  text: "${group?.firstName??""} ${group?.lastName??""}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              trailing: SizedBox(
                                width: 50, // Adjust width as needed to fit both icons
                                child: Row(
                                  mainAxisSize: MainAxisSize.min, // Ensures row takes minimal space
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        individualController.chatId.value = int.tryParse(group?.userId??"")??0;
                                        individualController.chatType.value = "private";
                                        individualController.onInit();
                                        individualController.update();
                                        Get.toNamed(Routes.chatDetailIndividual);
                                      },
                                      child: SizedBox(
                                        width: screenWidth*0.06,
                                        child: Image.asset(
                                          'assets/images/messenger.png',
                                          height: 23,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                      : Center(child: Text("No User Found")),
                    ),
                  ),
                ],
              ),
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
  
}