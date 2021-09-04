import 'package:day_8/model/post_model.dart';
import 'package:day_8/service/post_service.dart';

class PostRepository{
  PostService _postService = PostService();
  Future<List<PostModel>> fetchData() async {
    return _postService.fetchData();
  }
}