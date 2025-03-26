import 'package:bravo/app/constants/app_colors/app_colors.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import '../models/event_model.dart';
import 'dart:io';

import 'file_preview_doc_screen.dart';
import 'file_preview_screen.dart'; // Import dart:io for File

class ViewEventScreen extends StatelessWidget {
  const ViewEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Event event = Get.arguments as Event; // Access the passed event
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.02),
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
                Container(
                  padding: const EdgeInsets.all(12),
                  child: const Text(
                    'View Event',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  width: screenWidth,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screenHeight * 0.02),
                      _buildReadOnlyField('Event Name', event.title),
                      _buildReadOnlyField(
                          'Start Date & Time',
                          DateFormat('dd/MM/yyyy HH:mm').format(event.startTime??DateTime.now())),
                      _buildReadOnlyField(
                          'End Date & Time',
                          DateFormat('dd/MM/yyyy HH:mm').format(event.endTime??DateTime.now())),
                      _buildReadOnlyField('Location', event.location),
                      _buildReadOnlyField('Category', event.category?.catName??''),
                      _buildReadOnlyField('Group Name',
                          event.groups?.map((group) => group.name).join(', ') ??
                              'N/A'), // Display group names or N/A
                      _buildReadOnlyField('Event Cost', "\$${event.cost}" ?? 'N/A'),
                    _buildReadOnlyField('Document',
                      event.eventDoc!.isNotEmpty ? event.eventDoc!.first : 'N/A',
                      filePaths: event.eventDoc,
                    ),

                    _buildReadOnlyField('Event Notes', event.eventNotes??"N/A"),
                      _buildReadOnlyField('Announcements', event.description ?? 'N/A'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String? value, {List<String>? filePaths}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            color: AppColors.textLightColor,
          ),
        ),
        const SizedBox(height: 5),
        if (filePaths != null && filePaths.isNotEmpty)
          _buildFileList(filePaths)
        else
          Container(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Text(
              value ?? 'N/A',
              style: const TextStyle(color: AppColors.calendarColor),
            ),
          ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildFileList(List<String> filePaths) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: filePaths.map((filePath) => _buildNetworkFilePreview(filePath)).toList(),
    );
  }

  Widget _buildNetworkFilePreview(String fileUrl) {
    String fileName = fileUrl.split('/').last;

    return InkWell(
      onTap: () async {
        try {
          Get.dialog(
            Center(child: CircularProgressIndicator()), // Show loading
            barrierDismissible: false,
          );

          final directory = await getApplicationDocumentsDirectory();
          final filePath = '${directory.path}/$fileName';

          await Dio().download(fileUrl, filePath);

          Get.back(); // Close loading indicator

          // Determine file type and open accordingly
          if (fileUrl.endsWith('.png') ||
              fileUrl.endsWith('.jpg') ||
              fileUrl.endsWith('.jpeg') ||
              fileUrl.endsWith('.gif')) {
            Get.dialog(Dialog(child: Image.file(File(filePath))));
          } else if (fileUrl.endsWith('.pdf')) {
            Get.to(() => FilePreviewScreen(filePath: filePath));
          } else if (fileUrl.endsWith('.doc') ||
              fileUrl.endsWith('.docx')) {
            Get.to(() => FilePreviewDocScreen(filePath: fileUrl));
          } else {
            Get.snackbar("File Type", "Cannot preview this file type.");
          }
        } catch (e) {
          Get.back(); // Close loading indicator in case of error
          Get.snackbar("Error", "An error occurred: $e");
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.only(top: 8,bottom: 8),
        decoration: BoxDecoration(
          // border: Border.all(color: Colors.grey),
          // borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Icon(Icons.file_copy),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                fileName,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
