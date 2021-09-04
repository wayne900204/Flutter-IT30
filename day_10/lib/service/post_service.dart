import 'dart:convert';
import 'package:day_10/model/post_model.dart';
import 'package:http/http.dart' as http;

const timeout = Duration(seconds: 10);

class PostService {
  Future<List<PostModel>> fetchData() async {
    var uri = Uri.https('jsonplaceholder.typicode.com', '/posts');
    final response = await http.get(uri).timeout(timeout);
    return List<PostModel>.from(json.decode(response.body).map((c) => PostModel.fromJson(c)).toList());
  }
}