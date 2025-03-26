import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../constants/app_colors/app_colors.dart';
import '../controllers/unique_code_controller.dart';

class UniqueCodeScreen extends StatelessWidget {
  UniqueCodeScreen({super.key});
  final UniqueCodeController controller = Get.put(UniqueCodeController());
  final TextEditingController textController = TextEditingController();


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
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: screenHeight * 0.15,
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: screenHeight * 0.04,
                backgroundColor: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(screenHeight * 0.01),
                  child: Image.asset('assets/images/logo.png'),
                ),
              ),
            ),
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
                        controller: textController,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          fontSize: screenHeight * 0.025,
                          letterSpacing: 10,
                        ),
                        decoration: InputDecoration(
                          hintText: '1234567891',
                          hintStyle: TextStyle(color: Colors.black54),
                          contentPadding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.otpBorderColor, width: 1.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.otpBorderColor, width: 2.0),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.otpBorderColor, width: 1.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    Obx(() => controller.isLoading.value
                        ? Center(child: CircularProgressIndicator())
                        : GestureDetector(
                      onTap: () {
                        controller.fetchUserData(textController.text.trim());
                      },
                      child: Center(
                        child: Image.asset(
                          'assets/images/sign_in.png',
                          height: screenHeight * 0.2,
                        ),
                      ),
                    )),
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
