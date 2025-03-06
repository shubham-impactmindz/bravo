import 'package:bravo/app/constants/app_colors/app_colors.dart';
import 'package:bravo/app/modules/controllers/edit_event_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app/modules/models/event_model.dart';

class CustomAlertDialog extends StatelessWidget {
  final Event event;
  final String title;
  final String message;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;
  final EditEventController controller;

  const CustomAlertDialog({
    Key? key,
    required this.event,
    required this.controller,
    required this.title,
    required this.message,
    required this.onCancel,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      actionsPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.white,
      title: Container(
        color: AppColors.popUpColor.withOpacity(0.25),
        width: screenWidth,
        padding: EdgeInsets.all(10),
        child: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Roboto', // Match font family
            fontWeight: FontWeight.w500, // Match font weight
            fontSize: 18, // Match font size
            color: AppColors.textDarkColor, // Match title color
          ),
        ),
      ),
      content: Container(
        padding: EdgeInsets.all(10),
        child: Text(
          message,
          textAlign:TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Roboto', // Match font family
            fontSize: 16, // Match font size
            fontWeight: FontWeight.w500, // Match font weight
            color: AppColors.textDarkColor, // Match message color
          ),
        ),
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 10,),


            Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.borderColor,width: 0.61),
                  bottom: BorderSide(color: AppColors.borderColor,width: 0.61),
                  right: BorderSide(color: AppColors.borderColor,width: 0.61),
                  left: BorderSide(color: AppColors.borderColor,width: 0.61))),
              padding: EdgeInsets.all(10),
              child: GestureDetector(
                onTap:(){
                  Get.back();
                },
                child: const Text(
                  'No, cancel',
                  style: TextStyle(
                    fontFamily: 'Roboto', // Match font family
                    fontWeight: FontWeight.w500, // Match font weight
                    color: AppColors.textDarkColor, // Match text color
                  ),
                ),
              ),
            ),

            Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),color: AppColors.popUpColor.withOpacity(0.25),),
              padding: EdgeInsets.all(10),
              child: GestureDetector(
                onTap:(){
                  Get.back();
                  controller.eventSelectedDate.value=event;
                  controller.initializeEventData();
                  controller.update();
                  controller.deleteEvent();
                },
                child: const Text(
                  'Yes, Delete',
                  style: TextStyle(
                    fontFamily: 'Roboto', // Match font family
                    fontWeight: FontWeight.w500, // Match font weight
                    color: AppColors.textDarkColor, // Match text color
                  ),
                ),
              ),
            ),

            SizedBox(width: 10,),
          ],
        ),

        SizedBox(height: 20,)
      ],
    );
  }
}