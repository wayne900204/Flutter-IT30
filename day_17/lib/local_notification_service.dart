import 'package:day_17/my_router.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'main.dart';

class LocalNotificationService {
  static void initialize(BuildContext context) {
    /// 初始化 LocalNotification 的動作。
    /// iOS 這邊還需要加上其他設定。
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/ic_launcher"));
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }
}

class FCMManager {
  static void onMessageOpenedApp(BuildContext context) {
    ///When the app is in background but opened and user taps
    ///on the notification
    /// 從背景處中點擊推播當 App 縮小狀態時，開啟應用程式時，該流會發送 RemoteMessage。背景處理。
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('從背景中打開' + message.toString());
      final routeFromMessage = message.data["route"];
      if(routeFromMessage!=Null && routeFromMessage==RouteName.secondPage) {
        Navigator.of(context).pushNamed(routeFromMessage);
      }
    });
  }

  static void foregroundMessage() {
    /// foreground work
    /// 前景處理
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('前景處理 FcM 觸發' + message.toString());
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                icon: android.smallIcon,
              ),
            ));
      }
    });
  }
}
