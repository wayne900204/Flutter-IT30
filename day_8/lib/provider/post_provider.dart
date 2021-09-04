import 'package:day_8/model/post_model.dart';
import 'package:day_8/respository/post_respository.dart';
import 'package:flutter/cupertino.dart';

enum SortState { sortWithId, sortWithTitle, sortWithBody, sortWithUserId }

class PostProvider extends ChangeNotifier {
  PostRepository _postRepository = PostRepository();

  SortState _sortState = SortState.sortWithId;

  SortState get sortState => _sortState;

  List<PostModel> _posts = [];

  List<PostModel> get posts => _posts;

  fetchData(SortState sortState) async {
    _sortState = sortState;
    _posts = await _postRepository.fetchData();
    if (_sortState == SortState.sortWithId) {
      _posts.sort((a, b) => a.id.compareTo(b.id));
    } else if (_sortState == SortState.sortWithTitle) {
      _posts.sort((a, b) => a.title.compareTo(b.title));
    } else if (_sortState == SortState.sortWithBody) {
      _posts.sort((a, b) => a.body.compareTo(b.body));
    } else if (_sortState == SortState.sortWithUserId) {
      _posts.sort((a, b) => a.userId.compareTo(b.userId));
    }
    notifyListeners();
  }
}