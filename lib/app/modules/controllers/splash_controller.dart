// app/modules/splash/controllers/splash_controller.dart
import 'package:bravo/app/modules/views/unique_code_screen.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../views/home_screen.dart';

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
    Get.offAll(HomeScreen());
  }

  void _navigateToUnique() async {
    await Future.delayed(Duration(seconds: 3));
    Get.offAll(UniqueCodeScreen());
  }
}