import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

import '../../constants/app_colors/app_colors.dart';
import '../controllers/edit_event_controller.dart';
import '../models/group_list_model.dart';

class EditEventScreen extends StatelessWidget {
  EditEventScreen({super.key});

  final EditEventController controller = Get.put(EditEventController());

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
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Image.asset('assets/images/back.png', height: 30),
                    ),
                    const SizedBox(width: 20),
                    const Text(
                      'Edit Event',
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
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20),),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildEventNameField(),
                        buildDateTimeField('Start Date & Time', controller.startDateTime, DateTime.now()),
                        buildDateTimeField('End Date & Time', controller.endDateTime, DateTime.now()),
                        buildLocationField(),
                        buildCategoryDropdown(),
                        buildMultiSelectDropdown(),
                        buildEventCostField(),
                        buildFileField(),
                        buildEventNotesField(),
                        buildAnnouncementField(),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            controller.editEvent();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.popUpColor.withOpacity(0.50),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: Text('SAVE', style: TextStyle(color: AppColors.calendarColor)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Full-Screen Loader Overlay
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
    return buildTextField('Event Name', controller.eventNameController);
  }

  Widget buildLocationField() {
    return buildLocationFileTextField('Location', controller.locationController,isLocation: true);
  }


  Widget buildFileField() {
    return buildFilesField();
  }

  Widget buildEventCostField() {
    return buildTextField('Event Cost', controller.eventCostController);
  }

  Widget buildEventNotesField() {
    return buildTextField('Event Notes', controller.eventNotesController, isMultiline: true);
  }

  Widget buildAnnouncementField() {
    return buildTextField('Announcement', controller.announcementController, isMultiline: true);
  }

  Widget buildTextField(String label, TextEditingController controller, {bool isMultiline = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label*', style: const TextStyle(fontWeight: FontWeight.w400, color: AppColors.textLightColor)),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          maxLines: isMultiline ? 4 : 1,
          decoration: InputDecoration(
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
        Text('Files*', style: TextStyle(fontWeight: FontWeight.w400, color: AppColors.textLightColor)),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: () {
            controller.pickFileOrImage();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: Colors.black),
                SizedBox(width: 10),
                Text('Add Files'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Obx(() => GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: controller.previousFiles.length + controller.pickedFiles.length,
          itemBuilder: (context, index) {
            bool isPrevious = index < controller.previousFiles.length;
            return Stack(
              alignment: Alignment.topRight,
              children: [
                isPrevious
                    ? Image.network(controller.previousFiles[index], fit: BoxFit.cover)
                    : Image.file(controller.pickedFiles[index - controller.previousFiles.length], fit: BoxFit.cover),
                GestureDetector(
                  onTap: () => isPrevious ? controller.removePreviousFile(index) : controller.removeFile(index - controller.previousFiles.length),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                    child: Icon(Icons.close, color: Colors.white, size: 18),
                  ),
                ),
              ],
            );
          },
        )),
      ],
    );
  }

  Widget buildDateTimeField(String label, RxString dateTime, DateTime initialDate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label*', style: const TextStyle(fontWeight: FontWeight.w400, color: AppColors.textLightColor)),
        const SizedBox(height: 5),
        Obx(() => GestureDetector(
          onTap: () => controller.pickDateTime(dateTime, initialDate),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Expanded(child: Text(dateTime.value, style: const TextStyle(color: Colors.black))),
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