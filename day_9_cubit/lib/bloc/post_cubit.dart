import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/post_model.dart';
import '../respository/post_respository.dart';

part 'post_bloc_state.dart';

enum SortState { userId, id, title, body }

class PostCubit extends Cubit<IPostState> {
  IPostRepository _repository;
  List<PostModel> postList = [];

  PostCubit(IPostRepository repository)
      : _repository = repository,
        super(PostLoading());

  Future<void> fetchData() async {
    postList = await _repository.fetchData();
    sort(SortState.id);
  }

  void sort(SortState sortBy) {
    switch (sortBy) {
      case SortState.userId:
        postList.sort((a, b) => a.userId.compareTo(b.userId));
        break;
      case SortState.id:
        postList.sort((a, b) => a.id.compareTo(b.id));

        break;
      case SortState.title:
        postList.sort((a, b) => a.title.compareTo(b.title));
        break;
      case SortState.body:
        postList.sort((a, b) => a.body.compareTo(b.body));
        break;
    }
    emit(PostSuccess([...postList]));
  }
}
