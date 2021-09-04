import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:day_8/model/post_model.dart';


class PostService {
  Future<List<PostModel>> fetchData() async {
    var url = Uri.https('jsonplaceholder.typicode.com', '/posts');
    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return List<PostModel>.from(json
          .decode(response.body)
          .map((c) => PostModel.fromJson(c))
          .toList());
    } else {
      developer.log("FetchData StatusCode：", error: response.statusCode);
      throw Exception();
    }
  }
}
