
import 'dart:io';

import 'package:bravo/app/modules/models/categories_list_model.dart';
import 'package:bravo/app/modules/models/group_list_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../constants/app_colors/app_colors.dart';
import '../apiservice/api_service.dart';
import '../models/event_model.dart';
import 'calendar_controller.dart';

class EditEventController extends GetxController {
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController eventCostController = TextEditingController();
  final TextEditingController eventNotesController = TextEditingController();
  final TextEditingController announcementController = TextEditingController();
  final TextEditingController fileController = TextEditingController();

  var startDateTime = ''.obs;
  var endDateTime = ''.obs;
  var selectedCategory = ''.obs;
  var selectedGroups = <GroupList>[].obs;
  var groups = <GroupList>[].obs; // Changed to a list of GroupList instead of Rxn<GroupList>
  var category = <CategoryList>[].obs;
  final ApiService _apiService=ApiService();
  var eventSelectedDate = Event().obs;
  var pickedFiles = <File>[].obs;
  var documentPath = ''.obs;
  var fileName = ''.obs;
  var initialFileName = ''.obs; // Store the initial file name
  var previousFiles = <String>[].obs;
  var showFileName = false.obs;
  var isLoading=false.obs;
  final calendarController = Get.find<CalendarController>();

  @override
  Future<void> onInit() async {
    super.onInit();

    isLoading.value = true; // Show loader while fetching data

    await fetchGroupList();  // Ensure groups are fetched
    await fetchCategoryList(); // Ensure categories are fetched

    initializeEventData(); // Now call initialization AFTER data is available

    isLoading.value = false; // Hide loader once data is set
  }

  void initializeEventData() {
    eventNameController.text = eventSelectedDate.value.title ?? '';
    locationController.text = eventSelectedDate.value.location ?? '';
    eventCostController.text = eventSelectedDate.value.cost?.toString() ?? '';
    eventNotesController.text = eventSelectedDate.value.eventNotes ?? '';
    announcementController.text = eventSelectedDate.value.description ?? '';

    startDateTime.value = eventSelectedDate.value.startTime != null
        ? DateFormat('dd/MM/yyyy hh:mm a').format(eventSelectedDate.value.startTime!)
        : '';

    endDateTime.value = eventSelectedDate.value.endTime != null
        ? DateFormat('dd/MM/yyyy hh:mm a').format(eventSelectedDate.value.endTime!)
        : '';

    selectedCategory.value = eventSelectedDate.value.category?.catName ?? '';

    // Handle file name
    fileName.value = eventSelectedDate.value.eventDoc?.isNotEmpty == true
        ? eventSelectedDate.value.eventDoc![0].split('/').last
        : '';

    initialFileName.value = fileName.value;
    showFileName.value = fileName.value.isNotEmpty; // Show file if exists

    // Ensure groups list is available before selecting groups
    if (groups.isNotEmpty) {
      // Map existing group objects to their IDs for fast lookup
      Map<int, GroupList> groupMap = {
        for (var group in groups) int.tryParse(group.groupId.toString()) ?? -1: group
      };

      // Match selected groups to fetched groups
      List<GroupList> updatedGroups = eventSelectedDate.value.groups?.map((group) {
        int groupId = int.tryParse(group.groupId.toString()) ?? -1;
        return groupMap[groupId] ?? group; // Use existing group object if available
      }).toList() ?? [];

      selectedGroups.value = updatedGroups;
    }
    pickedFiles.clear();
    previousFiles.assignAll(eventSelectedDate.value.eventDoc ?? []);
    update();
  }


  Future<void> pickDateTime(RxString dateTimeField, DateTime initialDate) async {
    DateTime initialDateTime = initialDate; // Initialize with initialDate

    if (dateTimeField.value.isNotEmpty) {
      try {
        List<String> parts = dateTimeField.value.split(" ");
        List<String> dateParts = parts[0].split("/");
        List<String> timeParts = parts[1].split(":");

        int year = int.parse(dateParts[2]);
        int month = int.parse(dateParts[1]);
        int day = int.parse(dateParts[0]);

        int hour = int.parse(timeParts[0]);
        int minute = int.parse(timeParts[1]);

        initialDateTime = DateTime(year, month, day, hour, minute);
      } catch (e) {
        print("Parsing Failed: $e");
        Get.snackbar("Error", "Invalid date/time format. Using event's original date.");
        // initialDateTime remains as initialDate if parsing fails.
      }
    }

    DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: initialDateTime, // Use initialDateTime (now always initialized)
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: Get.context!,
        initialTime: TimeOfDay.fromDateTime(initialDateTime), // Use initialDateTime
      );

      if (pickedTime != null) {
        DateTime finalDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        dateTimeField.value = DateFormat('dd/MM/yyyy hh:mm a').format(finalDateTime);
      }
    }
  }

  @override
  void onClose() {
    eventNameController.dispose();
    locationController.dispose();
    eventCostController.dispose();
    eventNotesController.dispose();
    announcementController.dispose();
    super.onClose();
  }

  Future<void> fetchGroupList() async {
    try {
      var response = await _apiService.fetchGroupList();
      if (response.isSuccess ?? false && response.data != null) {
        groups.assignAll(response.data??[]); // Assigning the list of groups
      } else {
        Get.snackbar('Error', response.message ?? 'Failed to fetch groups');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong while fetching groups');
    }
  }

  void updateSelectedGroups(List<GroupList> selected) {
    selectedGroups.value = selected;
    update();
  }


  Future<void> fetchCategoryList() async {
    try {
      var response = await _apiService.fetchCategoryList();
      if (response.isSuccess ?? false) {
        category.assignAll(response.data ?? []);
      } else {
        Get.snackbar('Error', response.message ?? 'Failed to fetch categories');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong while fetching categories');
    }
  }

  Future<void> pickFileOrImage() async {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: const Text("Choose an option")),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    Navigator.of(context).pop();
                    await _pickFiles();
                  },
                  child: Column(children: [
                    Icon(Icons.file_copy, color: Colors.black, size: 50),
                    Text('Pick Files'),
                  ]),
                ),
                SizedBox(width: 30),
                GestureDetector(
                  onTap: () async {
                    Navigator.of(context).pop();
                    await _captureImage();
                  },
                  child: Column(children: [
                    Icon(Icons.camera_alt_outlined, color: Colors.black, size: 50),
                    Text('Take Photo'),
                  ]),
                ),
              ],
            ),
          ],
        );
      },
    );
  }


  Future<void> _captureImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedImage = await picker.pickImage(source: ImageSource.camera);
      if (pickedImage != null) {
        pickedFiles.add(File(pickedImage.path));
        update();
      }
    } catch (e) {
      Get.snackbar("Error", "Could not capture image: $e");
    }
  }

  void removeFile(int index) {
    pickedFiles.removeAt(index);
    update();
  }

  void removePreviousFile(int index) {
    previousFiles.removeAt(index);
    update();
  }

  Future<void> _pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: true,
      );

      if (result != null) {
        pickedFiles.addAll(result.files.map((file) => File(file.path!)));
        update();
      }
    } catch (e) {
      Get.snackbar("Error", "Could not pick files: $e");
    }
  }

  void resetFile() {
    fileName.value = initialFileName.value; // Restore initial file name
    showFileName.value = false; // Hide the row
    fileController.text = fileName.value;
    pickedFiles.value = [];
  }

  Future<void> editEvent() async {
    if (eventNameController.text.isEmpty) {
      showErrorSnackbar('Event name cannot be empty');
      return;
    }
    if (startDateTime.value.isEmpty) {
      showErrorSnackbar('Please select start date & time');
      return;
    }
    if (endDateTime.value.isEmpty) {
      showErrorSnackbar('Please select end date & time');
      return;
    }
    if (locationController.text.isEmpty) {
      showErrorSnackbar('Location cannot be empty');
      return;
    }
    if (selectedCategory.isEmpty) {
      showErrorSnackbar('Please select a category');
      return;
    }
    if (selectedGroups.isEmpty) {
      showErrorSnackbar('Please select groups');
      return;
    }
    if (fileName.value.isEmpty) {
      showErrorSnackbar('Please select file');
      return;
    }
    if (eventCostController.text.isEmpty) {
      showErrorSnackbar('Event cost cannot be empty');
      return;
    }
    if (eventNotesController.text.isEmpty) {
      showErrorSnackbar('Event notes cannot be empty');
      return;
    }
    if (announcementController.text.isEmpty) {
      showErrorSnackbar('Announcement cannot be empty');
      return;
    }

    isLoading.value = true;
    update();

    try {
      List<String> groupIds = selectedGroups.map((group) => group.groupId.toString()).toList();
      // List<String> userIds = ["164"]; // Adjust user ID as needed

      DateTime now = DateTime.now();

      // Format the date and time
      String deviceTime = DateFormat('dd/MM/yyyy hh:mm a').format(now);
      Map<String, dynamic> requestBody = {
        "title": eventNameController.text,
        "description": announcementController.text,
        "start_time": formatDateTime(startDateTime.value),
        "end_time": formatDateTime(endDateTime.value),
        "location": locationController.text,
        "category": selectedCategory.value,
        "cost": eventCostController.text,
        "group_id": groupIds.toString(),
        // "user_id": userIds.toString(),
        "event_notes": eventNotesController.text,
        "device_time": deviceTime,
      };

      if(pickedFiles.isEmpty){

        var response = await _apiService.updateEvent(
            requestBody, pickedFiles,false,eventSelectedDate.value.eventId??'');
        if (response.isSuccess ?? false) {
          Get.snackbar('Success', response.message ?? '', colorText: AppColors.white, backgroundColor: AppColors.calendarColor);

          calendarController.fetchEvents();
        } else {
          showErrorSnackbar(response.message ?? 'Failed to update event');
        }
      }
      else {
        var response = await _apiService.updateEvent(
            requestBody, pickedFiles,true,eventSelectedDate.value.eventId??'');
        if (response.isSuccess ?? false) {
          Get.snackbar('Success', response.message ?? '', colorText: AppColors.white, backgroundColor: AppColors.calendarColor);

          calendarController.fetchEvents();
        } else {
          showErrorSnackbar(response.message ?? 'Failed to update event');
        }
      }

    } catch (e) {
      showErrorSnackbar('Something went wrong');
    } finally {
      isLoading.value = false;
      update();
    }
  }

  String formatDateTime(String dateTimeStr) {
    try {
      // Parse the string in "dd/MM/yyyy hh:mm a" format
      DateTime parsedDate = DateFormat("dd/MM/yyyy hh:mm a").parse(dateTimeStr);

      // Format to "yyyy-MM-dd HH:mm:ss"
      return DateFormat("yyyy-MM-dd HH:mm:ss").format(parsedDate);
    } catch (e) {
      return ""; // Return empty string if parsing fails
    }
  }

  void showErrorSnackbar(String message) {
    Get.snackbar('Error', message, colorText: AppColors.white, backgroundColor: AppColors.calendarColor);
  }

  Future<void> deleteEvent() async {

    isLoading.value = true;
    calendarController.isLoading.value=true;
    calendarController.update();
    update();

    try {
      var response = await _apiService.deleteEvent(eventSelectedDate.value.eventId??'');
      if (response.isSuccess ?? false) {
        Get.snackbar('Success', response.message ?? '', colorText: AppColors.white, backgroundColor: AppColors.calendarColor);
        calendarController.fetchEvents();
        calendarController.update();
      } else {
        showErrorSnackbar(response.message ?? 'Failed to delete event');
      }


    } catch (e) {
      showErrorSnackbar('Something went wrong');
    } finally {
      isLoading.value = false;
      calendarController.isLoading.value=false;
      update();
      calendarController.update();
    }
  }
}
