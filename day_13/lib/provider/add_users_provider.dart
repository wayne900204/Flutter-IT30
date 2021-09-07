import 'dart:async';

import 'package:day_13/db/user_db.dart';
import 'package:day_13/models/userModel.dart';
import 'package:flutter/material.dart';

class AddUsersProvider extends ChangeNotifier {
  /// 取得所有 user 資料的 controller
  final _usersController = StreamController<List<UserModel>>.broadcast();

  Stream<List<UserModel>> get getUserStream => _usersController.stream;

  /// 新增的 controller
  final _insertController = StreamController<UserModel>.broadcast();

  /// 更新的 controller
  final _updateController = StreamController<UserModel>.broadcast();

  /// 刪除的 controller
  final _deleteController = StreamController<int>.broadcast();

  /// 搜尋的 controller
  final _searchController = StreamController<String>.broadcast();

  /// Sink
  StreamSink<UserModel> get insert => _insertController.sink;

  StreamSink<UserModel> get update => _updateController.sink;

  StreamSink<int> get delete => _deleteController.sink;

  StreamSink<String> get search => _searchController.sink;

  /// 初始化
  AddUsersProvider() {
    updateScreenData();
    _updateController.stream
        .listen((userModel) => _handleUpdateUser(userModel));
    _insertController.stream.listen((userModel) => _handleAddUser(userModel));
    _deleteController.stream
        .listen((userModel) => _handleDeleteUser(userModel));
    _searchController.stream
        .listen((userModel) => _handleSearchUser(userModel));
  }

  /// 新增
  void _handleAddUser(UserModel userModel) async {
    await UserDB.db.insertUserData(userModel);
    updateScreenData();
  }

  /// 更新
  void _handleUpdateUser(UserModel userModel) async {
    await UserDB.db.updateUser(userModel);
    updateScreenData();
  }

  /// 刪除
  void _handleDeleteUser(int id) async {
    await UserDB.db.deleteUser(id);
    updateScreenData();
  }

  /// 搜尋
  void _handleSearchUser(String text) async {
    List<UserModel> user = await UserDB.db.getUser();
    var listData = <UserModel>[];
    user.forEach((stud) {
      var st2 = UserModel(
          id: stud.id,
          lastName: stud.lastName,
          firstName: stud.firstName,
          time: stud.time);
      if ((st2.firstName.toLowerCase() + " " + st2.lastName.toLowerCase())
              .contains(text.toLowerCase()) ||
          st2.firstName.toLowerCase().contains(text.toLowerCase()) ||
          st2.lastName.toLowerCase().contains(text.toLowerCase()) ||
          st2.time.toLowerCase().contains(text.toLowerCase())) {
        listData.add(stud);
      }
    });
    _usersController.sink.add(listData);
  }

  /// 取得資料
  void updateScreenData() async {
    List<UserModel> users = await UserDB.db.getUser();
    _usersController.sink.add(users);
  }

  @override
  void dispose() {
    _usersController.close();
    _insertController.close();
    _deleteController.close();
    _updateController.close();
    _searchController.close();
    UserDB.db.close();
    super.dispose();
  }
}
