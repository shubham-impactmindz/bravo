import 'package:bravo/app/constants/app_colors/app_colors.dart';
import 'package:bravo/app/modules/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../apiservice/api_service.dart';
import '../apiservice/notification_service.dart';
import '../models/unique_code_model.dart';

class UniqueCodeController extends GetxController {
  var isLoading = false.obs;
  var user = Rxn<UserModel>();
  final ApiService _apiService = ApiService();
  NotificationService notificationService= NotificationService();

  Future<void> fetchUserData(String authCode) async {
    notificationService.requestNotificationPermission();
    notificationService.foregroundMessage();
    String? token=await notificationService.getDeviceToken();
    if (authCode.isEmpty) {
      Get.snackbar('Error', 'Unique code cannot be empty',colorText: AppColors.white,backgroundColor: AppColors.calendarColor);
      return;
    }

    isLoading.value = true;
    update();
    try {
      var response = await _apiService.fetchUserData({"auth_code": authCode,"device_token":token});
      if (response.isSuccess) {
        user.value = response.userInfo;

        await _saveUserId(response.userInfo?.userId ?? '',response.token?? '');
        Get.offAllNamed(Routes.home);
        Get.snackbar('Success', response.message,colorText: AppColors.white,backgroundColor: AppColors.calendarColor);
      } else {
        Get.snackbar('Error', response.message,colorText: AppColors.white,backgroundColor: AppColors.calendarColor);
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong',colorText: AppColors.white,backgroundColor: AppColors.calendarColor);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _saveUserId(String userId,String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
    await prefs.setString('token', token);
  }
}