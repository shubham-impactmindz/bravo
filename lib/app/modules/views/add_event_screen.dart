import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

import '../../constants/app_colors/app_colors.dart';
import '../controllers/add_event_controller.dart';
import '../controllers/edit_event_controller.dart';
import '../models/group_list_model.dart';

class AddEventScreen extends StatelessWidget {
  AddEventScreen({super.key});

  final AddEventController controller = Get.put(AddEventController());

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // ✅ Keeps the status bar transparent
        statusBarIconBrightness: Brightness.light, // ✅ White icons on dark backgrounds
        statusBarBrightness: Brightness.dark, // ✅ Ensures compatibility on iOS
      ),
    );
    return Scaffold(
      backgroundColor: AppColors.calendarColor,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    const Text(
                      'Add Event',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildEventNameField(),
                            buildDateTimeField('Start Date & Time', controller.startDateTime),
                            buildDateTimeField('End Date & Time', controller.endDateTime),
                            buildLocationField(),
                            buildCategoryDropdown(),
                            buildMultiSelectDropdown(),  // MultiSelect Dropdown with preselected groups
                            buildEventCostField(),
                            buildFileField(),
                            buildEventNotesField(),
                            buildAnnouncementField(),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                controller.saveEvent();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.popUpColor.withOpacity(0.50),
                                minimumSize: const Size(double.infinity, 50),
                              ),
                              child: Text('SAVE', style: TextStyle(color: AppColors.calendarColor)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          Obx(() => controller.isLoading.value
              ? Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          )
              : const SizedBox()),
        ],
      ),
    );
  }


  Widget buildEventNameField() {
    return buildTextField('Event Name', controller.eventNameController,'Please Enter Event Name');
  }

  Widget buildLocationField() {
    return buildLocationFileTextField('Location', controller.locationController,isLocation: true);
  }


  Widget buildFileField() {
    return buildFilesField();
  }

  Widget buildEventCostField() {
    return buildTextField('Event Cost', controller.eventCostController,'Please Enter Event Cost');
  }

  Widget buildEventNotesField() {
    return buildTextField('Event Notes', controller.eventNotesController,'Please Enter Event Notes', isMultiline: true);
  }

  Widget buildAnnouncementField() {
    return buildTextField('Announcement', controller.announcementController,'Please Enter Announcement', isMultiline: true);
  }

  Widget buildTextField(String label, TextEditingController controller, String hintText, {bool isMultiline = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label*', style: const TextStyle(fontWeight: FontWeight.w400, color: AppColors.textLightColor)),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          maxLines: isMultiline ? 4 : 1,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: AppColors.textLightColor),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget buildLocationFileTextField(String label, TextEditingController textController, {bool isFile = false,bool isLocation = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label*', style: const TextStyle(fontWeight: FontWeight.w400, color: AppColors.textLightColor)),
        const SizedBox(height: 5),

        TextField(
          readOnly: false,
          controller: textController,
          decoration: InputDecoration(
            filled: true,
            hintText: 'Enter Location',
            hintStyle: TextStyle(color: AppColors.textLightColor),
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            suffixIcon: isFile?Icon(Icons.file_copy):Icon(Icons.location_pin),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }


  Widget buildFilesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Files*', style: TextStyle(fontWeight: FontWeight.w400, color: AppColors.textLightColor)),
        const SizedBox(height: 5),
        Obx(() => Column(
          children: [
            // 📂 Grid to Show Selected Files
            if (controller.pickedFiles.isNotEmpty)
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 3 columns
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: controller.pickedFiles.length,
                itemBuilder: (context, index) {
                  File file = controller.pickedFiles[index];
                  String fileName = controller.fileNames[index];
                  bool isImage = fileName.endsWith('.jpg') || fileName.endsWith('.jpeg') || fileName.endsWith('.png');

                  return Stack(
                    children: [
                      // Show Image Preview or File Icon
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: isImage
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(file, fit: BoxFit.cover),
                        )
                            : Center(
                          child: Icon(Icons.insert_drive_file, size: 40, color: Colors.grey),
                        ),
                      ),
                      // ❌ Remove Button
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () => controller.removeFile(index),
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.close, color: Colors.white, size: 18),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            const SizedBox(height: 10),

            // ➕ Button to Add More Files
            GestureDetector(
              onTap: () => controller.pickFilesOrImages(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Add Files/Images',
                        style: TextStyle(color: AppColors.textLightColor),
                      ),
                    ),
                    Icon(Icons.add),
                  ],
                ),
              ),
            ),
          ],
        )),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget buildDateTimeField(String label, RxString dateTimeField) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label*', style: const TextStyle(fontWeight: FontWeight.w400, color: AppColors.textLightColor)),
        const SizedBox(height: 5),
        Obx(() => GestureDetector(
          onTap: () => controller.pickDateTime(dateTimeField),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    dateTimeField.value.isEmpty ? "Please select date & time" : dateTimeField.value,
                    style: TextStyle(
                      color: dateTimeField.value.isEmpty ? Colors.grey : Colors.black,
                    ),
                  ),
                ),
                const Icon(Icons.calendar_today),
              ],
            ),
          ),
        )),
        const SizedBox(height: 10),
      ],
    );
  }



  Widget buildCategoryDropdown() {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Category*', style: const TextStyle(fontWeight: FontWeight.w400, color: AppColors.textLightColor)),
        const SizedBox(height: 5),
        DropdownButtonFormField<String>(
          value: controller.selectedCategory.value.isNotEmpty ? controller.selectedCategory.value : null,
          items: controller.category
              .map((category) => DropdownMenuItem<String>(value: category.catName, child: Text(category.catName ?? "")))
              .toList(),
          onChanged: (value) => controller.selectedCategory.value = value ?? "",
          hint: Text('Select Category'),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    ));
  }

  Widget buildMultiSelectDropdown() {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        Text(
          'Group Name*',
          style: const TextStyle(fontWeight: FontWeight.w400, color: AppColors.textLightColor),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: MultiSelectDialogField<GroupList>(
            items: controller.groups
                .map((group) => MultiSelectItem<GroupList>(group, group.name ?? ''))
                .toList(),
            title: const Text("Select Groups"),
            buttonText: const Text("Select Groups"),
            initialValue: controller.selectedGroups.toList(), // Ensure preselection
            onConfirm: (values) => controller.updateSelectedGroups(values),
            chipDisplay: MultiSelectChipDisplay<GroupList>(
              items: controller.selectedGroups
                  .map((group) => MultiSelectItem<GroupList>(group, group.groupId ?? ''))
                  .toList(),
              chipColor: AppColors.popUpColor.withOpacity(0.25),
              textStyle: const TextStyle(color: Colors.black),
            ),
          ),
        ),
      ],
    ));
  }
}