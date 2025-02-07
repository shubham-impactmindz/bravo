// app/modules/splash/controllers/splash_controller.dart
import 'package:get/get.dart';

import '../routes/app_pages.dart';

class UniqueCodeController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // _navigateToHome();
  }

  void _navigateToHome() async {
    await Future.delayed(Duration(seconds: 1));
    Get.toNamed(Routes.home);
  }
}