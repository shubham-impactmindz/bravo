// app/modules/splash/controllers/splash_controller.dart
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../routes/app_pages.dart';

class SplashController extends GetxController {
  @override
  Future<void> onInit() async {
    super.onInit();
    final prefs = await SharedPreferences.getInstance();
    String? userId= prefs.getString('userId');
    if((userId??"").isNotEmpty) {
      _navigateToHome();
    }
    else{
      _navigateToUnique();
    }
  }

  void _navigateToHome() async {
    await Future.delayed(Duration(seconds: 3));
    Get.offAllNamed(Routes.home);
  }

  void _navigateToUnique() async {
    await Future.delayed(Duration(seconds: 3));
    Get.offAllNamed(Routes.uniqueCode);
  }
}