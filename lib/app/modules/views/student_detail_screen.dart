import 'package:flutter/material.dart';
import 'package:bravo/app/constants/app_colors/app_colors.dart';
import 'package:get/get.dart';

class StudentDetailScreen extends StatelessWidget {
  const StudentDetailScreen({super.key});

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
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: AssetImage("assets/images/user.png"),
                      ),
                      SizedBox(width: 20,),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Pranav Ray",
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
                                _buildSettingsCard(screenHeight, screenWidth),// Extract settings card
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                ),
              ),
            ),
          ],
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
            _buildProfileField("Name", "Pranav"),
            _buildProfileField("Surname", "Ray"),
            _buildProfileField("Email", "tim.jennings@example.com"),
            _buildProfileField("Contact No", "(603) 555-0123"),
            _buildProfileField("Group", "10th B"),
            _buildProfileField("Address", "101 Independence Avenue, S.E."),
            _buildProfileField("City", "Suburb"),
            _buildProfileField("Post Code", "3004"),
            _buildProfileField("State", "Melbourne"),
            _buildProfileField("Country", "Australia"),
            _buildProfileField("Notes", ""),
          ],
        ),
      ),
    );
  }



  Widget _buildSettingsCard(double screenHeight, double screenWidth) {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Relatives Parties',style: TextStyle(color: AppColors.popUpColor,fontWeight: FontWeight.w500, fontSize: 14),),
            SizedBox(height: screenHeight*0.01,),
            _buildProfileField("Related 1", "Darrell Steward"),
            _buildProfileField("Email", "darrell@gmail.com"),
            _buildProfileField("Contact No", "(704) 555-0127"),
            _buildProfileField("Mother Name", "Priyanka Steward"),
            _buildProfileField("Contact No", "(704) 555-0127"),
          ],
        ),
      ),
    );
  }



  // ... (rest of the code remains the same)
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