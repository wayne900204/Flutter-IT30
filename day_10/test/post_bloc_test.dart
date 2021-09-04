import 'package:bloc_test/bloc_test.dart';
import 'package:day_10/bloc/post_bloc.dart';
import 'package:day_10/model/post_model.dart';
import 'package:day_10/respository/post_respository.dart';
import 'package:flutter_test/flutter_test.dart';

class MockRepoImp extends IPostRepository {
  @override
  Future<List<PostModel>> fetchData() async => [
        PostModel(
            userId: 1, id: 1, title: 'Mickey title', body: 'this is the body'),
        PostModel(
            userId: 2, id: 2, title: 'Ruby title', body: 'this is the body'),
      ];
}

void main() {
  group('Post Bloc Test', () {
    blocTest<PostBloc, IPostState>(
      '確認 FetchPostData 的狀態是對的',
      build: () => PostBloc(repository: MockRepoImp()),
      act: (bloc) => bloc.add(FetchPostData()),
      // 設定事件的初始狀態
      seed: () => PostLoading(),
      // 設定 Delay 時間
      wait: const Duration(milliseconds: 300),
      expect: () => [
        // isA<PostLoading>(), // 初始化的狀態並不會被觸發
        isA<PostSuccess>(),
      ],
    );

    blocTest<PostBloc, IPostState>(
      '預設 Sort by Id',
      build: () => PostBloc(repository: MockRepoImp()),
      act: (bloc) => bloc.add(FetchPostData()),
      verify: (bloc) {
        final _state = bloc.state as PostSuccess;
        expect(_state.postList.length, 2);
        expect(_state.postList[0].id, 1);
        expect(_state.postList[1].id, 2);
      },
    );
    //
    blocTest<PostBloc, IPostState>(
      'Sorted by title',
      build: () => PostBloc(repository: MockRepoImp()),
      act: (bloc) => bloc
        ..add(FetchPostData())
        ..add(SortPostEvent(sortState: SortState.title)),
      expect: () => [
        isA<PostSuccess>(),
        isA<PostSuccess>(),
      ],
      verify: (bloc) {
        final _state = bloc.state as PostSuccess;
        expect(_state.postList.length, 2);
        expect(_state.postList[0].id, 1);
        expect(_state.postList[1].id, 2);
      },
    );
  });
}
