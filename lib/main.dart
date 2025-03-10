import 'package:bravo/app/modules/apiservice/get_service_key.dart';
import 'package:bravo/app/modules/apiservice/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'app/modules/controllers/chat_controller.dart';
import 'app/modules/routes/app_pages.dart';
import 'firebase_options.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

/// Handles background messages
Future<void> _backgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  _showLocalNotification(message);
}


void _showLocalNotification(RemoteMessage message) async {
  var androidDetails = const AndroidNotificationDetails(
    'channel_id', 'channel_name',
    importance: Importance.high,
    priority: Priority.high,
    playSound: true,
  );

  var iOSDetails = const DarwinNotificationDetails(
    presentAlert: true,  // Show alert when in foreground
    presentBadge: true,  // Update app badge count
    presentSound: true,  // Play sound
  );

  var notificationDetails = NotificationDetails(
    android: androidDetails,
    iOS: iOSDetails,
  );

  await flutterLocalNotificationsPlugin.show(
    DateTime.now().millisecondsSinceEpoch ~/ 1000, // Unique notification ID
    message.notification?.title ?? "No Title",
    message.notification?.body ?? "No Body",
    notificationDetails,
  );

  if (message.notification?.title?.toLowerCase() == "new message") {
    final ChatController chatController = Get.find<ChatController>();
    chatController.isLoading.value= false;
    chatController.fetchUserChats(); // Refresh chat list properly
    chatController.isLoading.value= false;
  }
}


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

// 🔹 iOS Initialization Settings
  var initializationSettingsIOS = const DarwinInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestAlertPermission: true,
  );

  // 🔹 Android Initialization Settings
  var initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');

  var initializationSettings = InitializationSettings(
    iOS: initializationSettingsIOS,
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      // Handle notification tap action
      if (response.payload != null) {
        // Perform action if required
      }
    },
  );

  // Register background handler
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
  }

  /// Request notification permission
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

  /// Listen for foreground and background messages
  void _setupFirebaseListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground notification received: ${message.notification?.title}");
      _showLocalNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Notification clicked: ${message.notification?.title}");
    });

    messaging.getToken().then((token) {
      print("FCM Token: $token");
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
