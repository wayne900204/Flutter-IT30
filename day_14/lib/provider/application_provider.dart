import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart'; // new
import 'package:day_14/models/guest_book_message.dart';
import 'package:day_14/src/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


class ApplicationProvider extends ChangeNotifier {
  // init Firebase
  ApplicationProvider() {
    init();
  }

  ApplicationLoginState _loginState = ApplicationLoginState.loggedOut;
  ApplicationLoginState get loginState => _loginState;

  String? _email;
  String? get email => _email;

  StreamSubscription<QuerySnapshot>? _guestBookSubscription;
  List<GuestBookMessage> _guestBookMessages = [];
  List<GuestBookMessage> get guestBookMessages => _guestBookMessages;

  int _attendees = 0;
  int get attendees => _attendees;

  Attending _attending = Attending.unknown;
  Attending get attending => _attending;

  StreamSubscription<DocumentSnapshot>? _attendingSubscription;

  /// 更新 firebase user 的參加狀態。
  /// 這邊更新後會觸發 firebase 的 userChanges().listen，然後信行 attending 的更新
  set attending(Attending attending) {
    final userDoc = FirebaseFirestore.instance
        .collection('attendees')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    if (attending == Attending.yes) {
      var map = {'attending': true};
      userDoc.set(map);
    } else {
      var map = {'attending': false};
      userDoc.set(map);
    }
  }

  Future<void> init() async {
    await Firebase.initializeApp();
    // 取得 attendees 參加人數的資料 的資料
    FirebaseFirestore.instance
        .collection('attendees')
        .where('attending', isEqualTo: true)
        .snapshots()
        .listen((snapshot) {
      _attendees = snapshot.docs.length;
      notifyListeners();
    });
    // 監聽使用者使否有登入的資訊
    FirebaseAuth.instance.userChanges().listen((user) {
      // 更改後，使用者從無登入 -> 已經登入的狀態
      if (user != null) {
        _loginState = ApplicationLoginState.loggedIn;
        // StreamSubscription 監聽資訊
        _guestBookSubscription = FirebaseFirestore.instance
            .collection('guestbook')
            .orderBy('timestamp', descending: true)
            .snapshots()
            .listen((snapshot) {
              // 先清空資料
          _guestBookMessages = [];
          snapshot.docs.forEach((document) {
            _guestBookMessages.add(
              GuestBookMessage(
                name: document.data()['name'].toString(),
                message: document.data()['text'].toString(),
              ),
            );
          });
          // 資料變動完後， rebuild 畫面
          notifyListeners();
        });
        // 監聽 attending 參加人數的資料
        _attendingSubscription = FirebaseFirestore.instance
            .collection('attendees')
            .doc(user.uid)
            .snapshots()
            .listen((snapshot) {
          if (snapshot.data() != null) {
            if (snapshot['attending']==true) {
              _attending = Attending.yes;
            } else {
              _attending = Attending.no;
            }
          } else {
            _attending = Attending.unknown;
          }
          notifyListeners();
        });
      } else {
        // 關閉監聽器
        _loginState = ApplicationLoginState.loggedOut;
        _guestBookMessages = [];
        _guestBookSubscription?.cancel();
        _attendingSubscription?.cancel(); // new
      }
      notifyListeners();
    });
  }
  /// 更新 firebase message 的留言狀態。
  /// 這邊更新後會觸發 firebase 的 userChanges().listen，然後信行 attending 的更新
  Future<DocumentReference> addMessageToGuestBook(String message) {
    if (_loginState != ApplicationLoginState.loggedIn) {
      throw Exception('Must be logged in');
    }
    var map = {
      'text': message,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'name': FirebaseAuth.instance.currentUser!.displayName,
      'userId': FirebaseAuth.instance.currentUser!.uid,
    };
    return FirebaseFirestore.instance.collection('guestbook').add(map);
  }
  // 更新 變成登入輸入 email 的畫面
  void startLoginFlow() {
    _loginState = ApplicationLoginState.emailAddress;
    notifyListeners();
  }
  // 取得現在 email 的資料是什麼
  Future<void> verifyEmail(
    String email, void Function(FirebaseAuthException e) errorCallback,
  ) async {
    try {
      var methods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      if (methods.contains('password')) {
        _loginState = ApplicationLoginState.password;
      } else {
        _loginState = ApplicationLoginState.register;
      }
      _email = email;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }
  // 有 Email 和 Password
  Future<void> signInWithEmailAndPassword(
    String email,
    String password,
    void Function(FirebaseAuthException e) errorCallback,
  ) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }
  // 取消註冊
  void cancelRegistration() {
    _loginState = ApplicationLoginState.emailAddress;
    notifyListeners();
  }
  // 註冊帳號，會有 email 和 password 和姓名
  Future<void> registerAccount(String email, String displayName, String password,
      void Function(FirebaseAuthException e) errorCallback) async {
    try {
      var credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await credential.user!.updateDisplayName(displayName);
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }
  // 登出
  void signOut() {
    FirebaseAuth.instance.signOut();
  }
}
