// app/routes/app_pages.dart

import 'package:bravo/app/modules/views/view_event_screen.dart';
import 'package:get/get.dart';

import '../views/chat_detail_screen.dart';
import '../views/edit_event_screen.dart';
import '../views/home_screen.dart';
import '../views/splash_screen.dart';
import '../views/student_detail_screen.dart';
import '../views/student_list_screen.dart';
import '../views/unique_code_screen.dart';


part 'app_routes.dart';


class AppPages {
  static const initial = Routes.splash;

  static final routes = [
    GetPage(name: Routes.splash, page: () => SplashScreen()),
    GetPage(name: Routes.uniqueCode, page: () => UniqueCodeScreen()),
    GetPage(name: Routes.home, page: () => HomeScreen()),
    GetPage(name: Routes.editEvent, page: () => EditEventScreen()),
    GetPage(name: Routes.studentDetail, page: () => StudentDetailScreen()),
    GetPage(name: Routes.studentList, page: () => StudentListScreen()),
    GetPage(name: Routes.chatDetail, page: () => ChatDetailScreen()),
    GetPage(name: Routes.viewEvent, page: () => ViewEventScreen()),
  ];
}