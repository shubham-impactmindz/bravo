
import 'dart:ffi';
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

class AddEventController extends GetxController {
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
  // 🆕 Multiple File Picker
  var pickedFiles = <File>[].obs; // Store selected files
  var fileNames = <String>[].obs; // Store file names
  var documentPath = ''.obs;
  var initialFileName = ''.obs; // Store the initial file name
  var showFileName = false.obs;
  var isLoading=false.obs;
  final calendarController = Get.find<CalendarController>();

  @override
  Future<void> onInit() async {
    super.onInit();
    await fetchGroupList();
    await fetchCategoryList();
  }

  Future<void> pickDateTime(RxString dateTimeField) async {
    DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: Get.context!,
        initialTime: TimeOfDay.fromDateTime(DateTime.now()),
      );

      if (pickedTime != null) {
        DateTime finalDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        // Format and save the selected DateTime
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

  // 🆕 Pick multiple images or files
  Future<void> pickFilesOrImages() async {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text("Choose an option")),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    Navigator.of(context).pop();
                    await _pickFiles();
                  },
                  child: Column(
                    children: [
                      const Icon(Icons.file_copy, color: Colors.black, size: 50),
                      const Text('Pick Files'),
                    ],
                  ),
                ),
                const SizedBox(width: 30),
                GestureDetector(
                  onTap: () async {
                    Navigator.of(context).pop();
                    await _captureImagesFromCamera();
                  },
                  child: Column(
                    children: [
                      const Icon(Icons.camera_alt, color: Colors.black, size: 50),
                      const Text('Capture Images'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // 📂 Pick multiple files (PDF, DOC, etc.)
  Future<void> _pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: true,
      );

      if (result != null) {
        for (var file in result.files) {
          pickedFiles.add(File(file.path!));
          fileNames.add(file.name);
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Could not pick files: $e");
    }
  }

  // 📷 Capture multiple images using the camera
  Future<void> _captureImagesFromCamera() async {
    final ImagePicker picker = ImagePicker();
    try {
      List<XFile> images = [];

      // Capture multiple images in a loop
      bool capturing = true;
      while (capturing) {
        final XFile? image = await picker.pickImage(source: ImageSource.camera);
        if (image != null) {
          images.add(image);
        } else {
          // Stop capturing when the user cancels
          capturing = false;
        }
      }

      // Add captured images to the list
      if (images.isNotEmpty) {
        for (var image in images) {
          pickedFiles.add(File(image.path));
          fileNames.add(image.name);
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Could not capture images: $e");
    }
  }


  void resetFiles() {
    pickedFiles.clear();
    fileNames.clear();
  }

  void resetForm() {
    eventNameController.text = '';
    startDateTime.value = '';
    endDateTime.value = '';
    locationController.text = '';
    selectedCategory.value = '';
    selectedGroups.value = [];
    eventCostController.text = '';
    eventNotesController.text = '';
    announcementController.text = '';
  }

  Future<void> saveEvent() async {
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
    if (fileNames.isEmpty) {
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
        "device_time":deviceTime,
      };

      var response = await _apiService.addEvent(requestBody, pickedFiles);

      if (response.isSuccess ?? false) {
        Get.snackbar('Success', response.message ?? '', colorText: AppColors.white, backgroundColor: AppColors.calendarColor);
        resetFiles();
        resetForm();
        calendarController.fetchEvents();
      } else {
        showErrorSnackbar(response.message ?? 'Failed to create event');
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

  // 🗑 Remove a specific file
  void removeFile(int index) {
    pickedFiles.removeAt(index);
    fileNames.removeAt(index);
  }
}
