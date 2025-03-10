import 'package:bravo/app/constants/app_colors/app_colors.dart';
import 'package:bravo/app/modules/models/notification_list_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../apiservice/api_service.dart';

class NotificationController extends GetxController {
  var isLoading = false.obs;
  final ApiService _apiService = ApiService();
  var page = 1.obs;
  var limit = 20.obs;
  ScrollController scrollController = ScrollController();
  RxBool hasMoreData = false.obs;
  RxBool isMoreLoading = false.obs;
  var notifications = <Notifications>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    fetchNotificationList();

    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && hasMoreData.value) {
        fetchMoreNotification();
      }
    });

  }

  Future<void> fetchNotificationList() async {

    isLoading.value = true;
    update();
    try {
      var response = await _apiService.fetchNotificationList(page.value, limit.value);
      if (response.status ?? false) {
        notifications.assignAll(response.notifications??[]);
        hasMoreData.value = (response.pagination?.totalPages ?? 1) > page.value;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (scrollController.hasClients && notifications.isNotEmpty) {
            scrollController.jumpTo(scrollController.position.maxScrollExtent+1000);
          }
        });
      } else {
        // Get.snackbar('Error', response.message??'',colorText: AppColors.white,backgroundColor: AppColors.calendarColor);
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong',colorText: AppColors.white,backgroundColor: AppColors.calendarColor);
    } finally {
      isLoading.value = false;
    }
  }



  Future<void> fetchMoreNotification() async {
    if (isMoreLoading.value || !hasMoreData.value) return;

    isMoreLoading.value = true;
    try {
      page++;
      var response = await _apiService.fetchNotificationList(page.value, limit.value);
      if (response.status ?? false) {
        if (response.notifications!.isNotEmpty) {
          notifications.addAll(response.notifications!);
        } else {
          hasMoreData.value = false;
        }
      } else {
        // Get.snackbar('Error', response.message ?? 'Failed to load more chats');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong');
    } finally {
      isMoreLoading.value = false;
    }
  }

  void showErrorSnackbar(String message) {
    Get.snackbar('Error', message, colorText: AppColors.white, backgroundColor: AppColors.calendarColor);
  }
}