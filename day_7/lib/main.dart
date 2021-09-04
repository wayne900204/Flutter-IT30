import 'dart:convert';

import 'package:day_7/model/post_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /// 初始化的資料，之後請求到資料後，存在這裡。
  PostModel? apidata;

  @override
  void initState() {
    super.initState();
    // 請求資料
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('API Sample'),
      ),
      body: Center(
        child: Text(
          apidata == null ? "" : apidata.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  void fetchData() async {
    // 請求時間最多幾秒
    const timeout = Duration(seconds: 10);
    // URI 可以傳入 String authority, String unencodedPath, [Map<String, dynamic>? queryParameters
    var url = Uri.https(
      'jsonplaceholder.typicode.com',
      '/posts/1',
    );
    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url).timeout(timeout);
    // 如果是 response.statusCode 是 200 的話，我們再去解析 Json
    if (response.statusCode == 200) {
      setState(() {
        apidata = PostModel.fromJson(json.decode(response.body));
      });
      // 如果需要 是 List<PostModel> 的話可以使用下面的方式。
      // List<PostModel>.from(json.decode(response.body).map((c) => PostModel.fromJson(c)).toList());
    } else {
      throw Exception();
    }
  }
}
