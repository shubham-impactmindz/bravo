import 'package:flutter/material.dart';
import 'package:bravo/app/constants/app_colors/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.calendarColor,
      body: SafeArea(
        child: Column(
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

                                Row(
                                  children: [
                                    Stack(
                                      children: [
                                        CircleAvatar(
                                          radius: 35,
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
                                    SizedBox(width: 12),
                                    Text(
                                      "Jaini Shah",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
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
          children: [
            _buildProfileField("Email", "jainishah@samyak.com"),
            _buildProfileField("Contact No", "(406) 555-0120"),
            _buildProfileField("Address", "6391 Elgin St. Celina, Delaware"),
            _buildProfileField("Role", "Student"),
            _buildProfileField("Authentication Code", "346806788"),
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
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            _buildListTile('assets/images/about.png', "About Bravo"),
            _buildListTile('assets/images/privacy.png', "Privacy Policy"),
            _buildListTile('assets/images/logout.png', "Sign out",
                subtitle: "Further secure your account for safety"),
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

  Widget _buildListTile(String icon, String title, {String? subtitle}) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey[200],
        child: Image.asset(icon),
      ),
      title: Text(title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      subtitle: subtitle != null
          ? Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey))
          : null,
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
    );
  }
}