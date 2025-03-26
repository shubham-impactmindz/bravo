import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../app/constants/app_colors/app_colors.dart';
import '../app/modules/controllers/calendar_controller.dart';
import '../app/modules/controllers/edit_event_controller.dart';
import '../app/modules/models/event_model.dart';
import '../app/modules/routes/app_pages.dart';
import '../widgets/custom_alert_dialog.dart';

class EventListItem extends StatelessWidget {
  final Event event;
  final controller = Get.find<CalendarController>();
  final EditEventController editController = Get.put(EditEventController());

  EventListItem({super.key, required this.event});

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey, width: 0.5),
        ),
      ),
      child: ListTile(
        onTap: () {
          Get.toNamed(Routes.viewEvent, arguments: event);
        },
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              event.title??'',
              style: const TextStyle(
                fontSize: 18,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
                color: AppColors.textDarkColor,
              ),
            ),
            Row(
              children: [
                // Image.asset(
                //   'assets/images/messenger.png', // Make sure path is correct
                //   height: 20,
                // ),
                // SizedBox(width: screenWidth * 0.01),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'Edit') {
                      editController.eventSelectedDate.value=event;
                      editController.initializeEventData();
                      editController.update();
                      Get.toNamed(Routes.editEvent);
                    } else if (value == 'Delete') {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CustomAlertDialog(
                            event:event,
                            controller:editController,
                            title: 'Delete Event',
                            message: 'Please confirm you wish to delete this event?',
                            onCancel: () {
                              Navigator.of(context).pop();
                            },
                            onConfirm: () {

                            },
                          );
                        },
                      );
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'Edit',
                      child: Row(
                        children: [
                          Icon(Icons.mode_edit_outline_outlined,
                              color: AppColors.darkGreyIconColor),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'Delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline_outlined,
                              color: AppColors.darkGreyIconColor),
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
              DateFormat('dd/MM/yyyy HH:mm').format(event.date??DateTime.now()),
              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                color: AppColors.textLightColor,
              ),
            ),
            Row(
              children: [
                const Text(
                  'Created by: ',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    color: AppColors.textLightColor,
                  ),
                ),
                Text(
                  event.createdByName ?? "",
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    color: AppColors.textDarkColor,
                  ),
                ),
                const SizedBox(width: 15),
                if (event.cost != null)
                  Row(
                    children: [
                      const Text(
                        'Cost: ',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          color: AppColors.textLightColor,
                        ),
                      ),
                      Text(
                        "\$${event.cost.toString()}",
                        style: const TextStyle(
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