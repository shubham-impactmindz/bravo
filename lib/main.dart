import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/modules/routes/app_pages.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bravo',
      initialRoute: Routes.splash,
      getPages: AppPages.routes,
      theme: ThemeData(fontFamily: 'Roboto'),
    );
  }
}
