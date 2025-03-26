// app/routes/app_pages.dart

import 'package:bravo/app/modules/views/all_user_list_screen.dart';
import 'package:bravo/app/modules/views/chat_detail_individual_screen.dart';
import 'package:bravo/app/modules/views/view_event_screen.dart';
import 'package:bravo/app/modules/views/webview_screen.dart';
import 'package:get/get.dart';

import '../views/about_screen.dart';
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
    GetPage(name: Routes.chatDetailIndividual, page: () => ChatDetailIndividualScreen()),
    GetPage(name: Routes.viewEvent, page: () => ViewEventScreen()),
    GetPage(name: Routes.about, page: () => AboutScreen()),
    GetPage(name: Routes.webView, page: () => WebViewScreen()),
    GetPage(name: Routes.allUser, page: () => AllUserListScreen()),
  ];
}