import 'package:day_17/my_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'local_notification_service.dart';
/// 背景 Handler for FCM
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // 確保初執行前有初始化
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}
/// flutterLocalNotificationsPlugin 初始設定
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.max,
);
/// flutterLocalNotificationsPlugin 初始宣告
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  /// 背景處理
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  /// 創建一個 Android 通知通道。
  /// 我們在`AndroidManifest.xml`文件中使用這個通道來覆蓋
  /// 默認 FCM 通道啟用抬頭通知。
  /// https://github.com/FirebaseExtended/flutterfire/blob/master/packages/firebase_messaging/firebase_messaging/example/lib/main.dart
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    /// 初始化 LocalNotification 設定
    LocalNotificationService.initialize(context);
    ///gives you the message on which user taps
    ///and it opened the app from terminated state
    /// App 被完全關掉後，時點選通知開啟App（Terminated）
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print('從 App 被完全關閉狀態打開：' + message.data["route"]);
        final routeFromMessage = message.data["route"];
        Navigator.pushNamed(context, routeFromMessage);
      }
    });
    /// 監聽 terminal 推播事件。
    FCMManager.foregroundMessage();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: RouteName.homePage,
      onGenerateRoute: MyRouter.generateRoute,
    );
  }
}
