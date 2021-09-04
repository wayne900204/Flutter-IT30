import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/post_model.dart';
import '../respository/post_respository.dart';
part 'post_bloc_event.dart';
part 'post_bloc_state.dart';

enum SortState { userID, id, title, body }

class PostBloc extends Bloc<IPostEvent, IPostState> {
  final IPostRepository _repository;

  List<PostModel> postList = [];
  /// 設定初始狀態 super(這裡要放初始狀態)
  PostBloc({required IPostRepository repository}) : _repository = repository,super(PostLoading());

  @override
  Stream<IPostState> mapEventToState(IPostEvent event) async* {
    // 如果是件事 FetchPostData
    if (event is FetchPostData) {yield* _fetchData(event);}
    // 如果是件事 SortPostEvent
    else if(event is SortPostEvent){yield* _sortState(event);}
  }

  Stream<IPostState> _fetchData(FetchPostData event) async* {
    // 請求 API
    postList = await _repository.fetchData();
    // 觸發另一個排序事件 SortPostEvent
    add(SortPostEvent(sortState: SortState.id));
  }
  // 自定義的 method
  Stream<IPostState> _sortState(SortPostEvent event) async* {
    _sort(event.sortState);
    yield PostSuccess(postList);
  }
  // sort method
  Future<void> _sort(SortState sortState)async {
    switch (sortState) {
      case SortState.title:
        postList.sort((a, b) => a.title.compareTo(b.title));
        break;
      case SortState.id:
        postList.sort((a, b) => a.id.compareTo(b.id));
        break;
      case SortState.userID:
        postList.sort((a, b) => a.userId.compareTo(b.userId));
        break;
      case SortState.body:
        postList.sort((a, b) => a.body.compareTo(b.body));
        break;
    }
  }
}