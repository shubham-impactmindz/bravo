import 'package:bravo/app/constants/app_colors/app_colors.dart';
import 'package:bravo/app/modules/models/user_chat_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app/modules/controllers/chat_controller.dart';

class EventCard extends StatelessWidget {

  final AllMessage message;
  final ChatController controller = Get.put(ChatController());
  EventCard(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.popUpColor.withOpacity(.25),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.title??'',
            style: TextStyle(fontSize: 16,color: AppColors.calendarColor),
          ),
          SizedBox(height: 5),
          Text(message.description??'',
              style: TextStyle(color: AppColors.calendarColor),),
          SizedBox(height: 10),
          (message.userStatus??'').isEmpty?Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [

              Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),
                    border: Border(top: BorderSide(color: AppColors.borderColor,width: 0.61),
                        bottom: BorderSide(color: AppColors.borderColor,width: 0.61),
                        right: BorderSide(color: AppColors.borderColor,width: 0.61),
                        left: BorderSide(color: AppColors.borderColor,width: 0.61))),
                padding: EdgeInsets.all(10),
                child: GestureDetector(
                  onTap:(){

                    controller.updateEventStatus(eventId:message.eventId,status: 'rejected');
                    controller.update();
                  },
                  child: const Text(
                    'Reject',
                    style: TextStyle(
                      fontFamily: 'Roboto', // Match font family
                      fontWeight: FontWeight.w500, // Match font weight
                      color: AppColors.textDarkColor, // Match text color
                    ),
                  ),
                ),
              ),

              SizedBox(width: 10),

              Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),color: AppColors.calendarColor,),
                padding: EdgeInsets.all(10),
                child: GestureDetector(
                  onTap:(){
                    controller.updateEventStatus(eventId:message.eventId,status: 'accepted');
                    controller.update();
                  },
                  child: const Text(
                    'Accept',
                    style: TextStyle(
                      fontFamily: 'Roboto', // Match font family
                      fontWeight: FontWeight.w500, // Match font weight
                      color: AppColors.white, // Match text color
                    ),
                  ),
                ),
              ),


            ],
          ):

          Text(message.userStatus?.toUpperCase()??'',
            style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: message.userStatus=="accepted"?Colors.green:
            Colors.red),),
        ],
      ),
    );
  }
}