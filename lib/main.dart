import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'app/constants/app_colors/app_colors.dart';
import 'app/modules/apiservice/api_service.dart';
import 'app/modules/controllers/chat_controller.dart';
import 'app/modules/controllers/chat_individual_controller.dart';
import 'app/modules/routes/app_pages.dart';
import 'firebase_options.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

/// ✅ 1. Background and Terminated State Handler
@pragma('vm:entry-point') // Required for background execution
Future<void> _backgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("✅ [Background] Notification received: ${message.notification?.title}");

  if (message.notification != null) {
    _showLocalNotification(message, message.data);
  }
}

/// ✅ 2. Show Local Notification
void _showLocalNotification(RemoteMessage message, Map<String, dynamic> data) async {
  if (message.notification == null) return;

  var androidDetails = const AndroidNotificationDetails(
    'channel_id',
    'channel_name',
    importance: Importance.high,
    priority: Priority.high,
    playSound: true,
  );

  var iOSDetails = const DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  var notificationDetails = NotificationDetails(
    android: androidDetails,
    iOS: iOSDetails,
  );
  print('notifications aa gyi bro');
  String payload = jsonEncode(data);

  await flutterLocalNotificationsPlugin.show(
    DateTime.now().millisecondsSinceEpoch ~/ 1000,
    message.notification?.title ?? "No Title",
    message.notification?.body ?? "No Body",
    notificationDetails,
    payload: payload,
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  var initializationSettingsIOS = const DarwinInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestAlertPermission: true,
  );

  var initializationSettingsAndroid =
  const AndroidInitializationSettings('@mipmap/ic_launcher');

  var initializationSettings = InitializationSettings(
    iOS: initializationSettingsIOS,
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      if (response.payload != null) {
        _handleNotificationTap(response.payload!);
      }
    },
  );

  FirebaseMessaging.onBackgroundMessage(_backgroundHandler);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    _requestNotificationPermission();
    _setupFirebaseListeners();
    _checkInitialMessage(); // Check for initial message here
  }

  /// Request Notification Permission
  void _requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    }
  }

  /// Setup Firebase Listeners
  void _setupFirebaseListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground notification received: ${message.notification?.title}");
      _showLocalNotification(message, message.data);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Notification clicked: ${message.notification?.title}");
      if (message.data.isNotEmpty) {
        _handleNotificationTap(jsonEncode(message.data));
      }
    });

    messaging.getToken().then((token) {
      print("FCM Token: $token");
    });
  }

  Future<void> _checkInitialMessage() async {
    FirebaseMessaging.instance.getInitialMessage().then((
        RemoteMessage? message) {
      if (message != null && message.data.isNotEmpty) {
        _handleNotificationTap(jsonEncode(message.data));
      }
    });
  }

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

/// ✅ 5. Handle Notification Tap and Redirect
Future<void> _handleNotificationTap(String payload) async {
  try {
    Map<String, dynamic> data = jsonDecode(payload);

    String screenName = data["screen_name"] ?? "";
    String chatId = data["chat_id"] ?? "";
    String chatType = data["chat_type"] ?? "";
    String eventId = data["event_id"] ?? "";

    switch (screenName) {
      case "message":
        if (chatType == "private") {
          final ChatController individualController = Get.put(ChatController());
          individualController.chatId.value = int.tryParse(chatId) ?? 0;
          individualController.chatType.value = "private";
          individualController.onInit();
          Get.toNamed(Routes.chatDetail);
        } else {
          print('screen group wali');
          final ChatController chatController = Get.put(ChatController());
          chatController.chatId.value = int.tryParse(chatId) ?? 0;
          chatController.chatType.value = chatType;
          chatController.onInit();
          Get.toNamed(Routes.chatDetail);
        }
        break;

      case "event":
        var isLoading = false.obs;
        final ApiService apiService = ApiService();
        isLoading.value = true;
        try {
          var fetchedEvents = await apiService.fetchEventById(eventId);

          Get.toNamed(Routes.viewEvent, arguments: fetchedEvents);
        }
        catch (e){
          Get.snackbar('Error', 'Something went wrong',colorText: AppColors.white,backgroundColor: AppColors.calendarColor);
        } finally{
          isLoading.value = false;
        }
        break;

      default:
        Get.toNamed(Routes.home);
    }
  } catch (e) {
    print("Error decoding payload: $e");
    Get.toNamed(Routes.home);
  }
}