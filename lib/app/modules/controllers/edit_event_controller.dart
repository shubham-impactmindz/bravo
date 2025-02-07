import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EditEventController extends GetxController {
  var eventName = ''.obs;
  var startDateTime = ''.obs;
  var endDateTime = ''.obs;
  var location = ''.obs;
  var selectedCategories = <String>[].obs;
  var groupName = ''.obs;
  var eventCost = ''.obs;
  var document = ''.obs;
  var eventNotes = ''.obs;
  var announcement = ''.obs;

  void pickDateTime(bool isStart) async {
    DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: Get.context!,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        DateTime finalDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        String formattedDate = DateFormat('dd/MM/yyyy  hh:mm a').format(finalDateTime);
        if (isStart) {
          startDateTime.value = formattedDate;
        } else {
          endDateTime.value = formattedDate;
        }
      }
    }
  }
}