import 'package:day_11/contorller/post_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'model/post_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(title: 'GetX Sample'),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  final PostController controller = Get.put(PostController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: <Widget>[
            PopupMenuButton<SortState>(
              icon: Icon(Icons.more_vert),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Text('使用 userId 排序'),
                  value: SortState.userID,
                ),
                PopupMenuItem(
                  child: Text('使用 id 排序'),
                  value: SortState.id,
                ),
                PopupMenuItem(
                  child: Text('使用 title 排序'),
                  value: SortState.title,
                ),
                PopupMenuItem(
                  child: Text('使用 body 排序'),
                  value: SortState.body,
                )
              ],
              onSelected: (SortState value) {
                Get.find<PostController>().sort(value);
              },
            )
          ],
        ),
        body: _MyListView());
  }
}

class _MyListView extends StatelessWidget {
  _MyListView({Key? key}) : super(key: key);
  final PostController controller = Get.find<PostController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.isLoading.value
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: controller.postList.length,
            itemBuilder: (context, index) {
              PostModel item = controller.postList[index];
              return Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      color: Colors.white,
                      border: Border.all(color: Colors.blueAccent, width: 2.0)),
                  margin: EdgeInsets.all(8),
                  padding: EdgeInsets.all(8),
                  child: RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        TextSpan(
                          text: item.id.toString() + ". " + item.title,
                          style: TextStyle(fontSize: 18, color: Colors.red),
                        ),
                        TextSpan(
                          text: '\n' + item.body,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: "\nUser ID：" + item.userId.toString(),
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ));
            },
          ));
  }
}
