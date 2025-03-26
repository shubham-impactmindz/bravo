import 'package:bravo/app/modules/models/student_detail_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bravo/app/constants/app_colors/app_colors.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/chat_controller.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [

              SizedBox(height: screenHeight * 0.02),
              Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: () {
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
                ],
              ),
              Container(
                alignment: Alignment.center,
                height: screenHeight * 0.85,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Container(
                      height: MediaQuery.of(context).size.height*0.17,
                      width: MediaQuery.of(context).size.width*0.55,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset('assets/images/logo.png'),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height*0.03,),
                    Text(
                      'BRAVO',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height*0.03,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Roboto",
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.copyright,color: Colors.white,size: MediaQuery.of(context).size.height*0.025,),
                        SizedBox(width: 2,),
                        Text(
                          '2025',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height*0.022,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Roboto",
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'OUR COMPUTER GUY PTY. LIMITED',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height*0.022,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Roboto",
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}