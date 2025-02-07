import 'package:bravo/app/constants/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_pages.dart';
import '../controllers/unique_code_controller.dart';


class UniqueCodeScreen extends GetView<UniqueCodeController> {

  final ctrl = Get.put(UniqueCodeController());
  @override
  Widget build(BuildContext context) {
    // Screen dimensions
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.calendarColor, // Dark background color
      resizeToAvoidBottomInset: true, // Prevent overflow when keyboard appears
      body: SafeArea(
        child: Column(
          children: [
            // Logo Section (15% of screen height)
            Container(
              height: screenHeight * 0.15,
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: screenHeight * 0.04,
                backgroundColor: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(screenHeight * 0.01),
                  child: Image.asset('assets/images/logo.png'), // Replace with your logo
                ),
              ),
            ),
            // Unique Code Section
            Expanded(
              child: Container(
                width: screenWidth,
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: screenHeight * 0.02),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                      child: Text(
                        'Unique Code:',
                        style: TextStyle(
                          fontSize: screenHeight * 0.024,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                      child: TextField(
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          fontSize: screenHeight * 0.025,
                          letterSpacing: 20,
                        ),
                        decoration: InputDecoration(
                          hintText: '1234567891',
                          hintStyle: TextStyle(color: Colors.black54),
                          contentPadding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.otpBorderColor, width: 1.5), // Default border
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.otpBorderColor, width: 2.0), // Border when focused
                            borderRadius: BorderRadius.circular(12),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.otpBorderColor, width: 1.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    Spacer(), // Pushes the image to the bottom
                    GestureDetector(
                      onTap: (){
                        Get.toNamed(Routes.home);
                      },
                      child: Center(
                        child: Image.asset(
                          'assets/images/sign_in.png',
                          height: screenHeight * 0.2, // Adjust image size as needed
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
