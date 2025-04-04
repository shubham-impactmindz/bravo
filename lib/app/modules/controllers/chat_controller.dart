import 'dart:io';

import 'package:bravo/app/modules/controllers/message_controller.dart';
import 'package:bravo/app/modules/models/student_detail_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/app_colors/app_colors.dart';
import '../apiservice/api_service.dart';
import '../models/user_chat_model.dart';
import '../routes/app_pages.dart';

class ChatController extends GetxController {
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
  var pickedFile = File('').obs;
  var documentPath = ''.obs;
  var fileName = ''.obs;
  var initialFileName = ''.obs;
  late Map<String, dynamic> requestBody;
  final TextEditingController messageController = TextEditingController();
  var userId="".obs;
  var user = Rxn<StudentDetailModel>();

  @override
  void onInit() {
    super.onInit();
    fetchUserChats();

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
        await sendUserMessage(messageTypeId:"3",parentMessageId:"");
      } else {
        // User canceled the picker
      }
    } catch (e) {
      Get.snackbar("Error", "Could not pick file: $e");
    }
  }

  void resetFile() {
    fileName.value = initialFileName.value; // Restore initial file name
    pickedFile.value = File('');
  }

  Future<void> sendUserMessage({String? messageTypeId, String? parentMessageId}) async {
    isLoading.value = true;
    try {
      DateTime now = DateTime.now();

    // Format the date and time
    String deviceTime = DateFormat('dd/MM/yyyy hh:mm a').format(now);

    requestBody = {
        "message_type_id": messageTypeId ?? '',
        "content": messageTypeId == "1" ? messageController.text : "",
        "parent_message_id": parentMessageId ?? '',
        "chat_type": chatType.value,
        "is_read": "0",
        "group_id": chatType.value == "private" ? "" : chatId.value,
        "receiver_id": chatType.value == "private" ? chatId.value : "",
        "device_time": deviceTime,
      };
      var response = await _apiService.sendUserMessage(requestBody,pickedFile.value);
      if (response.isSuccess ?? false) {
        resetFile();
        messageController.clear();
        // Check if user is at the top (viewing older messages)
        // Check if user is on the first page
        if (page.value == 1) {
          // Fetch only the latest messages without resetting the list
          var newResponse = await _apiService.fetchUserMessage(chatType.value, chatId.value, 1, limit.value);

          if (newResponse.isSuccess ?? false) {
            if (chats.isNotEmpty) {
              // Only update the first page messages
              chats[0].allMessages!.clear();
              chats[0].allMessages!.addAll(newResponse.chats![0].allMessages!);
            } else {
              chats.addAll(newResponse.chats!);
            }
          }
        } else {
          // If user is on a different page, load only more chats instead of refreshing everything
          page.value -= 1;
          await fetchMoreChats(page);
        }

        chats.refresh();
        update();

        final MessageController controller = Get.put(MessageController());
        controller.onInit();
        controller.update();
      } else {
        if(response.isActive??false){
          Get.snackbar('Error', 'Failed to send message please try again',colorText: AppColors.white,backgroundColor: AppColors.calendarColor);
        }else{
          Get.snackbar('User Is Not Active', 'User Logged Out',colorText: Colors.white,
              backgroundColor: AppColors.calendarColor);
          SharedPreferences preferences = await SharedPreferences.getInstance();
          await preferences.clear();
          Get.offAllNamed(Routes.uniqueCode);
        }

      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong');
    }finally {
      isLoading.value = false;
    }
  }

  Future<void> updateEventStatus({String? eventId, String? status}) async {
    isLoading.value = true;
    try {
      requestBody = {
        "event_id": eventId ?? '',
        "status": status,
      };
      var response = await _apiService.updateEventStatus(requestBody);
      if (response.isSuccess ?? false) {
          await fetchUserChats();
      } else {
        Get.snackbar('Error', 'Failed to update event please try again',colorText: AppColors.white,backgroundColor: AppColors.calendarColor);
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong');
    }finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUserChats() async {
    isLoading.value = true;
    try {
      var response = await _apiService.fetchUserMessage(chatType.value, chatId.value, page.value, limit.value);
      if (response.isSuccess ?? false) {
        chats.assignAll(response.chats ?? []);
        hasMoreData.value = (response.chats?[0].messagesPagination?.totalPages ?? 1) > page.value;
        chats.refresh(); // Ensure UI updates
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (scrollController.hasClients && chats.isNotEmpty && chats[0].allMessages != null && chats[0].allMessages!.isNotEmpty) {
            scrollController.animateTo(scrollController.position.maxScrollExtent+1000,
            duration: Duration(milliseconds: 20), curve: Curves.easeInOut);
          }
        });
        if(hasMoreData.value){
          await fetchMoreChats(page);
        }
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
      // Get.snackbar('Error', 'Something went wrong');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUserDetail() async {
    isLoading.value = true;
    try {
      page.value = 1; // Reset page on initial load
      var response = await _apiService.fetchUserDetail(userId.value, chatId.value);
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

  Future<void> fetchUserDetailById() async {
    isLoading.value = true;
    try {
      page.value = 1; // Reset page on initial load
      var response = await _apiService.fetchUserDetailById(userId.value);
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

  Future<void> fetchMoreChats(RxInt page) async {

    isLoading.value = true; // Indicate loading state
    try {
      page++;
      var response = await _apiService.fetchUserMessage(chatType.value, chatId.value, page.value, limit.value);

      if (response.isSuccess ?? false) {
        if (chats.isNotEmpty) {
          // Append new messages at the end
          chats[0].allMessages!.addAll(response.chats![0].allMessages!);

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (scrollController.hasClients && chats.isNotEmpty && chats[0].allMessages != null && chats[0].allMessages!.isNotEmpty) {
              scrollController.jumpTo(scrollController.position.maxScrollExtent+1000);
            }
          });
        } else {
          chats.addAll(response.chats!);
        }

        hasMoreData.value = (response.chats?[0].messagesPagination?.totalPages ?? 1) > page.value;
        chats.refresh(); // Force UI refresh

        update(); // Update UI after adding messages

      } else {
        hasMoreData.value = false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void showScrollNotification() {
    Get.snackbar(
      'New Messages',
      'Scrolled to the latest message',
      colorText: AppColors.white,
      backgroundColor: AppColors.calendarColor,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 1),
    );
  }

  void showErrorSnackbar(String message) {
    Get.snackbar('Error', message, colorText: AppColors.white, backgroundColor: AppColors.calendarColor);
  }
}
