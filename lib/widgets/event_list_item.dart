import 'package:bravo/app/modules/routes/app_pages.dart';
import 'package:bravo/widgets/custom_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../app/constants/app_colors/app_colors.dart';
import '../app/modules/controllers/calendar_controller.dart';
import '../app/modules/models/event_model.dart';

class EventListItem extends StatelessWidget {
  final Event event;
  final controller = Get.find<CalendarController>();

  EventListItem({required this.event});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey, width: 0.5),
        ),
      ),
      child: ListTile(
        onTap: (){
          Get.toNamed(Routes.editEvent);
        },
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              event.title,
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
                color: AppColors.textDarkColor,
              ),
            ),
            Row(
              children: [
                Image.asset(
                  'assets/images/messenger.png',
                  height: 20,
                ),
                SizedBox(
                  width: screenWidth * 0.01,
                ),
                // PopupMenuButton is placed directly here
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'Edit') {
                      controller.editEvent(event);
                    } else if (value == 'Delete') {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CustomAlertDialog(
                            title: 'Delete Event',
                            message: 'Please confirm you wish to delete this event?',
                            onCancel: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            onConfirm: () {
                              // Perform delete action here
                              Navigator.of(context).pop(); // Close the dialog
                            },
                          );
                        },
                      );
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'Edit',
                      child: Row(
                        children: [
                          Icon(Icons.mode_edit_outline_outlined, color: AppColors.darkGreyIconColor),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'Delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline_outlined, color: AppColors.darkGreyIconColor),
                          SizedBox(width: 8),
                          Text('Delete'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat('dd/MM/yyyy HH:mm').format(event.date),
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                color: AppColors.textLightColor,
              ),
            ),
            if (event.createdBy != null)
              Row(
                children: [
                  Row(
                    children: [
                      Text(
                        'Created by: ',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          color: AppColors.textLightColor,
                        ),
                      ),
                      Text(
                        event.createdBy ?? "",
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          color: AppColors.textDarkColor,
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                    ],
                  ),
                  if (event.cost != null)
                    Row(
                      children: [
                        Text(
                          'Cost: ',
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                            color: AppColors.textLightColor,
                          ),
                        ),
                        Text(
                          event.cost.toString() ?? "",
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                            color: AppColors.textDarkColor,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}