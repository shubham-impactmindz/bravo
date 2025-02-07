import 'package:bravo/app/modules/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:bravo/app/constants/app_colors/app_colors.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../models/student_list_model.dart';

class StudentListScreen extends StatelessWidget {
  StudentListScreen({super.key});


  final List<StudentListModel> studentsList = [
    StudentListModel(
      name: "Adnan Safi",
      message: "Started following you",
      time: "5 min ago",
      avatar: "assets/images/user.png",
    ),
    StudentListModel(
      name: "Joan Baker",
      message: "Invite A virtual Evening of Smooth Jazz",
      time: "20 min ago",
      avatar: "assets/images/user.png",
    ),
    StudentListModel(
      name: "Ronald C. Kinch",
      message: "Like your events",
      time: "1 hr ago",
      avatar: "assets/images/user.png",
    ),
    StudentListModel(
      name: "Clara Tolson",
      message: "Join your Event Gala Music Festival",
      time: "9 hr ago",
      avatar: "assets/images/user.png",
    ),
    StudentListModel(
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
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundImage: AssetImage("assets/images/user.png"),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.edit,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 20,),

                      Column(
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
                child: ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: studentsList.length,
                  itemBuilder: (context, index) {
                    final notification = studentsList[index];
                    return Container(
                      margin: EdgeInsets.only(left: 10,right: 10),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey, width: 0.5),
                        ),
                      ),
                      child: ListTile(
                        onTap: (){
                          Get.toNamed(Routes.studentDetail);
                        },
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
                          ),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios,size: 15,),
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