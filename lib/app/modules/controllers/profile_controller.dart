import 'package:bravo/app/constants/app_colors/app_colors.dart';
import 'package:bravo/app/modules/models/user_details_model.dart';
import 'package:get/get.dart';
import '../apiservice/api_service.dart';

class ProfileController extends GetxController {
  var isLoading = false.obs;
  var user = Rxn<UserDetailsModel>();
  final ApiService _apiService = ApiService();

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
}