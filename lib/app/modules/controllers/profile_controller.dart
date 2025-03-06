import 'dart:io';

import 'package:bravo/app/constants/app_colors/app_colors.dart';
import 'package:bravo/app/modules/models/user_details_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../apiservice/api_service.dart';

class ProfileController extends GetxController {
  var isLoading = false.obs;
  var user = Rxn<UserDetailsModel>();
  final ApiService _apiService = ApiService();
  var pickedFile = File('').obs;
  var documentPath = ''.obs;
  var fileName = ''.obs;
  var initialFileName = ''.obs; // Store the initial file name
  var showFileName = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    fetchUserData();
  }

  Future<void> fetchUserData() async {

    isLoading.value = true;
    update();
    try {
      var response = await _apiService.fetchUserDetails();
      if (response.isSuccess??false) {
        user.value = response;

        // Get.snackbar('Success', response.message??'',colorText: AppColors.white,backgroundColor: AppColors.calendarColor);
      } else {
        Get.snackbar('Error', response.message??'',colorText: AppColors.white,backgroundColor: AppColors.calendarColor);
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong',colorText: AppColors.white,backgroundColor: AppColors.calendarColor);
    } finally {
      isLoading.value = false;
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
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    Navigator.of(context).pop(); // Close the dialog
                    await _pickFile(ImageSource.gallery);
                  },
                  child: Column(children: [
                    Icon(Icons.image_outlined,color: Colors.black,size: 50,),
                    Text('Pick File'),
                  ],),
                ),
                SizedBox(width: 30,),
                GestureDetector(
                  onTap: () async {
                    Navigator.of(context).pop(); // Close the dialog
                    await _pickFile(ImageSource.camera);
                  },
                  child: Column(children: [
                    Icon(Icons.camera_alt_outlined,color: Colors.black,size: 50,),
                    Text('Take Photo'),
                  ],),
                ),
              ],
            ),

          ],
        );
      },
    );
  }

  Future<void> _pickFile(ImageSource source) async {
    try {
      FilePickerResult? result;

      if (source == ImageSource.gallery) {
        result = await FilePicker.platform.pickFiles(
          type: FileType.any, // or FileType.image, FileType.pdf, etc.
          allowMultiple: false,
        );
      } else if (source == ImageSource.camera) {
        final ImagePicker picker = ImagePicker();
        final XFile? pickedImage = await picker.pickImage(source: source);
        if (pickedImage != null) {
          result = FilePickerResult([PlatformFile(path: pickedImage.path, name: pickedImage.name, size: await pickedImage.length())]);
        }
      }

      if (result != null) {
        pickedFile.value = File(result.files.first.path!);
        documentPath.value = result.files.first.path!;
        fileName.value = result.files.first.name;
        showFileName.value = true;
        updateProfilePicture();
      } else {
        // User canceled the picker
      }
    } catch (e) {
      Get.snackbar("Error", "Could not pick file: $e");
    }
  }

  void resetFile() {
    fileName.value = ''; // Restore initial file name
    showFileName.value = false; // Hide the row
    pickedFile.value = File('');
  }

  Future<void> updateProfilePicture() async {

    isLoading.value = true;
    update();

    try {

      var response = await _apiService.updateProfilePicture(pickedFile.value);

      if (response.isSuccess ?? false) {
        Get.snackbar('Success', response.message ?? '', colorText: AppColors.white, backgroundColor: AppColors.calendarColor);
        user.value?.userInfo?.profilePicture=response.profilePicture;
        update();
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

  void showErrorSnackbar(String message) {
    Get.snackbar('Error', message, colorText: AppColors.white, backgroundColor: AppColors.calendarColor);
  }
}