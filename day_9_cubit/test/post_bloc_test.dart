import 'package:bloc_test/bloc_test.dart';
import 'package:day_9/model/post_model.dart';
import 'package:day_9/respository/post_respository.dart';
import 'package:day_9/bloc/post_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
class MockRepoImp extends IPostRepository {
  @override
  Future<List<PostModel>> fetchData() async => [
    PostModel(userId: 1, id: 1, title: 'Mickey title', body: 'this is the body'),
    PostModel(userId: 2, id: 2, title: 'Ruby title', body: 'this is the body'),
  ];
}

void main() {
  group('Post Bloc Test', () {
    blocTest<PostCubit, IPostState>(
      '確認 FetchPostData 的狀態是對的',
      build: () => PostCubit( MockRepoImp()),
        act: (cubit) => cubit.fetchData(),
        expect: () => [
        // isA<PostLoading>(),// 初始狀態不會被 emitted. Check documentation
        isA<PostSuccess>(),
      ],
    );

    blocTest<PostCubit, IPostState>(
      '預設 Sort by Id',
      build: () => PostCubit( MockRepoImp()),
      act: (cubit) => cubit.fetchData(),
      verify: (cubit) {
        final readyState = cubit.state as PostSuccess;
        expect(readyState.postList.length, 2);
        expect(readyState.postList[0].id, 1);
        expect(readyState.postList[1].id, 2);
      },
    );
    //
    blocTest<PostCubit, IPostState>(
      'Sorted by title',
      build: () => PostCubit( MockRepoImp()),
      act: (cubit) => cubit..fetchData()..sort(SortState.title),
      expect: () => [
        isA<PostSuccess>(),
        isA<PostSuccess>(),
      ],
      verify: (cubit) {
        final readyState = cubit.state as PostSuccess;
        expect(readyState.postList.length, 2);
        expect(readyState.postList[0].id, 1);
        expect(readyState.postList[1].id, 2);
      },
    );
  });
}