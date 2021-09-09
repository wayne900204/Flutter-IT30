import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'local_notification_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// 要取得 device token，好讓 JS 檔案和 FCM TEST MESSAGE 可以傳送指定 token
  late String deviceToken;

  /// 訂閱的 Topic
  List subscribed = [];

  /// 有哪些頻道可供 topic 訂閱。
  List channels = [
    'channel1',
    'channel2',
    'channel3',
    'channel4',
    'channel5',
    'channel6',
    'channel7'
  ];

  @override
  void initState() {
    super.initState();

    /// 監聽背景推播
    FCMManager.onMessageOpenedApp(context);
    getToken();
    getTopics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FCM DEMO'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: channels.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(channels[index]),
          trailing: subscribed.contains(channels[index])
              ? ElevatedButton(
                  onPressed: () async => cancelSubscribed(index),
                  child: Text('unsubscribe'),
                )
              : ElevatedButton(
                  onPressed: () async => startSubscribed(index),
                  child: Text('subscribe')),
        ),
      ),
    );
  }

  /// 向 FCM 請求 device_token
  void getToken() async {
    var token = (await FirebaseMessaging.instance.getToken())!;
    setState(() {
      deviceToken = token;
    });
    print('device token:' + deviceToken);
  }

  /// 向 firebase 取得 collection == channels 並去找到 documnet == token 的那筆資料裡面的所有 key 值
  void getTopics() async {
    await FirebaseFirestore.instance
        .collection('channels')
        .get()
        .then((value) => value.docs.forEach((element) {
              if (deviceToken == element.id) {
                subscribed = element.data().keys.toList();
              }
            }));

    setState(() {
      subscribed = subscribed;
    });
  }

  /// 開始訂閱 topic 到 fireStore
  void startSubscribed(int index) async {
    await FirebaseMessaging.instance.subscribeToTopic(channels[index]);

    await FirebaseFirestore.instance
        .collection('channels')
        .doc(deviceToken)
        .set({channels[index]: 'subscribe'}, SetOptions(merge: true));
    setState(() {
      subscribed.add(channels[index]);
    });
  }

  /// 取消訂閱 topic from fireStore
  void cancelSubscribed(int index) async {
    await FirebaseMessaging.instance.unsubscribeFromTopic(channels[index]);
    await FirebaseFirestore.instance
        .collection('channels')
        .doc(deviceToken)
        .update({channels[index]: FieldValue.delete()});
    setState(() {
      subscribed.remove(channels[index]);
    });
  }
}
