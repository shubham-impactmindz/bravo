import 'package:bravo/app/constants/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class SplashScreen extends GetView<SplashController> {

  final ctrl = Get.put(SplashController());

  SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // ✅ Keeps the status bar transparent
        statusBarIconBrightness: Brightness.light, // ✅ White icons on dark backgrounds
        statusBarBrightness: Brightness.dark, // ✅ Ensures compatibility on iOS
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.calendarColor,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
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
            ],
          ),
        ),
      ),
    );
  }
}
