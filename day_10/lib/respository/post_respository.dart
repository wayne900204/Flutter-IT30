import 'package:day_10/model/post_model.dart';
import 'package:day_10/service/post_service.dart';

abstract class IPostRepository {
  Future<List<PostModel>> fetchData();
}

class PostRepository extends IPostRepository {
  final PostService _provider;

  PostRepository(this._provider);

  @override
  Future<List<PostModel>> fetchData() => _provider.fetchData();
}
