import 'package:app_settings/app_settings.dart';
import 'package:bravo/app/constants/app_colors/app_colors.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationService{
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String? token;

  void requestNotificationPermission() async{
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );
    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      print('user granted permission');
    } else if(settings.authorizationStatus == AuthorizationStatus.provisional){

      print('user provisional granted permission');
    } else{
      Get.snackbar('Notification permission denied', 'Please allow notifications to receive updates',colorText: Colors.white,
      backgroundColor: AppColors.calendarColor);
      Future.delayed(Duration(seconds: 2),(){
        AppSettings.openAppSettings(type: AppSettingsType.notification);
      });
    }
  }


  Future<String?> getDeviceToken() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      token = await messaging.getToken();
    }
    return token;
  }


  Future foregroundMessage() async {
    await messaging.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
  }
}