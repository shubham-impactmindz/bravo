import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/app_colors/app_colors.dart';
import '../apiservice/api_service.dart';
import '../models/user_chats_list_model.dart';
import '../routes/app_pages.dart';

class MessageController extends GetxController {
  var messages = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  final ApiService _apiService = ApiService();
  var page = 1.obs;
  var limit = 20.obs;
  var chats = <Chat>[].obs;
  var filteredChats = <Chat>[].obs; // ✅ New list for search results
  ScrollController scrollController = ScrollController();
  TextEditingController searchController = TextEditingController(); // ✅ Controller for search
  RxBool hasMoreData = false.obs;
  RxBool isMoreLoading = false.obs;


  @override
  void onInit() {
    super.onInit();
    fetchUserChats();

    // Add scroll listener for pagination
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && hasMoreData.value) {
        fetchMoreChats();
      }
    });

    // Listen for search input changes
    searchController.addListener(() {
      filterChats(searchController.text);
    });
  }

  Future<void> fetchUserChats() async {
    isLoading.value = true;
    try {
      var response = await _apiService.fetchMessages(page.value, limit.value);
      if (response.isSuccess ?? false) {
        chats.assignAll(response.chats ?? []);
        filteredChats.assignAll(chats); // ✅ Initialize filtered list with all chats
        hasMoreData.value = (response.pagination?.totalPages ?? 1) > page.value;
      } else {
        if(response.isActive??false){

        }else{
          Get.snackbar('User Is Not Active', 'User Logged Out',colorText: Colors.white,
              backgroundColor: AppColors.calendarColor);
          SharedPreferences preferences = await SharedPreferences.getInstance();
          await preferences.clear();
          Get.offAllNamed(Routes.uniqueCode);
        }
      }
    } catch (e) {

    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMoreChats() async {
    if (isMoreLoading.value || !hasMoreData.value) return;

    isMoreLoading.value = true;
    try {
      page++;
      var response = await _apiService.fetchMessages(page.value, limit.value);
      if (response.isSuccess ?? false) {
        if (response.chats!.isNotEmpty) {
          chats.addAll(response.chats!);
          filteredChats.assignAll(chats); // ✅ Update filtered list
        } else {
          hasMoreData.value = false;
        }
      } else {
        Get.snackbar('Error', response.message ?? 'Failed to load more chats');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong');
    } finally {
      isMoreLoading.value = false;
    }
  }

  // ✅ Search Filtering Function
  void filterChats(String query) {
    if (query.isEmpty) {
      filteredChats.assignAll(chats);
    } else {
      filteredChats.assignAll(
        chats.where((chat) => (chat.name ?? "").toLowerCase().contains(query.toLowerCase())).toList(),
      );
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    searchController.dispose();
    super.onClose();
  }


  void showErrorSnackbar(String message) {
    Get.snackbar('Error', message, colorText: AppColors.white, backgroundColor: AppColors.calendarColor);
  }
}
