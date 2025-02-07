import 'package:bravo/app/constants/app_colors/app_colors.dart';
import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
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
            'Design Event',
            style: TextStyle(fontSize: 16,color: AppColors.calendarColor),
          ),
          SizedBox(height: 5),
          Text('Lotum one GmbH is an Android game developer that has been active since 2019.',
              style: TextStyle(color: AppColors.calendarColor),),
          SizedBox(height: 10),
          Row(
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
          ),
        ],
      ),
    );
  }
}