import 'package:bravo/app/constants/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/edit_event_controller.dart';

class AddEventScreen extends StatelessWidget {
  AddEventScreen({super.key});

  final EditEventController controller = Get.put(EditEventController());

  @override
  Widget build(BuildContext context) {

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.calendarColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight*0.05),
            Container(
              padding: EdgeInsets.all(12),
              child: Text(
                'Add New Event',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.white,fontFamily: 'Roboto'),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screenHeight*0.02),
                      buildTextField('Event Name', controller.eventName, true),
                      buildDateTimeField('Start Date & Time', controller.startDateTime, true, true),
                      buildDateTimeField('End Date & Time', controller.endDateTime, true, false),
                      buildTextField('Location', controller.location, true, isLocation: true),
                      buildDropdownField('Group Name', ['10 Std Class A', '10 Std Class B'], controller.groupName),
                      buildTextField('Event Cost', controller.eventCost, true),
                      buildTextField('Add Document', controller.document, false, isFile: true),
                      buildTextField('Event Notes', controller.eventNotes, false, isMultiline: true),
                      buildTextField('Announcement', controller.announcement, true, isMultiline: true),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.popUpColor.withOpacity(0.50),
                          minimumSize: Size(double.infinity, 50),
                        ),
                        child: Text('SAVE',style: TextStyle(color: AppColors.calendarColor),),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, RxString controller, bool isRequired, {bool isMultiline = false, bool isFile = false, bool isLocation = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label${isRequired ? "*" : ""}',
          style: TextStyle(fontWeight: FontWeight.w400, color: AppColors.textLightColor),
        ),
        const SizedBox(height: 5),
        Obx(
              () => TextField(
            controller: TextEditingController(text: controller.value),
            onChanged: (value) => controller.value = value,
            maxLines: isMultiline ? 4 : 1,
            readOnly: isFile || isLocation,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              suffixIcon: isFile
                  ? Icon(Icons.attach_file)
                  : isLocation
                  ? Icon(Icons.location_on)
                  : null,
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget buildDateTimeField(String label, RxString textField, bool isRequired, bool isStart) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label${isRequired ? "*" : ""}',
          style: TextStyle(fontWeight: FontWeight.w400, color: AppColors.textLightColor),
        ),
        const SizedBox(height: 5),
        Obx(
              () => TextField(
            controller: TextEditingController(text: textField.value),
            readOnly: true,
            onTap: () => controller.pickDateTime(isStart),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              suffixIcon: Icon(Icons.calendar_today),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget buildDropdownField(String label, List<String> items, RxString controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label*',
          style: TextStyle(fontWeight: FontWeight.w400, color: AppColors.textLightColor),
        ),
        const SizedBox(height: 5),
        Obx(
              () => DropdownButtonFormField<String>(
            value: controller.value.isEmpty ? null : controller.value,
            items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (value) => controller.value = value!,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}