import 'dart:io';

import 'package:bravo/app/modules/controllers/message_controller.dart';
import 'package:bravo/app/modules/models/all_users_model.dart';
import 'package:bravo/app/modules/models/student_detail_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../constants/app_colors/app_colors.dart';
import '../apiservice/api_service.dart';
import '../models/user_chat_model.dart';

class AllUserController extends GetxController {
  var isLoading = false.obs;
  final ApiService _apiService = ApiService();
  var page = 1.obs;
  var limit = 50.obs;
  var chatId = 0.obs;
  var chatType = "".obs;
  var chats = <Chat>[].obs;
  ScrollController scrollController = ScrollController();
  RxBool hasMoreData = false.obs;
  RxBool isMoreLoading = false.obs;

  var userId="".obs;
  var user = Rxn<AllUsersModel>();

  @override
  void onInit() {
    super.onInit();
    fetchUserDetail();
  }


  Future<void> fetchUserDetail() async {
    isLoading.value = true;
    try {
      page.value = 1; // Reset page on initial load
      var response = await _apiService.fetchAllUser();
      if (response.isSuccess ?? false) {
        user.value = response;
      } else {
        // Handle error
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong');
    } finally {
      isLoading.value = false;
    }
  }

  // Future<void> fetchUserDetailById() async {
  //   isLoading.value = true;
  //   try {
  //     page.value = 1; // Reset page on initial load
  //     var response = await _apiService.fetchUserDetailById(userId.value);
  //     if (response.isSuccess ?? false) {
  //       user.value = response;
  //     } else {
  //       // Handle error
  //     }
  //   } catch (e) {
  //     Get.snackbar('Error', 'Something went wrong');
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void showErrorSnackbar(String message) {
    Get.snackbar('Error', message, colorText: AppColors.white, backgroundColor: AppColors.calendarColor);
  }
}
