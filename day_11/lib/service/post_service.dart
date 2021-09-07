import 'package:get/get_connect/connect.dart';

import '../model/post_model.dart';

class PostService extends GetConnect {
//  請求 Api
  Future<List<PostModel>> fetchData() async {
    return await get(
      'https://jsonplaceholder.typicode.com/posts',
      decoder: (data) =>
      List<PostModel>.from(data.map((e) => PostModel.fromJson(e))),
    ).then((value) => value.body!).catchError((e) => throw e);
  }
}
