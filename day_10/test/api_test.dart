import 'package:day_10/model/post_model.dart';
import 'package:day_10/service/post_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPostService extends Mock implements PostService {}

final _mockList = [
  PostModel(userId: 1, id: 1, title: 'Mickey title', body: 'this is the body'),
  PostModel(userId: 2, id: 2, title: 'Ruby title', body: 'this is the body'),
];

void main() {
  group('test_API', () {
    final _post_service = MockPostService();
    test(
        'returns List<PostModel> and called only one time if the http call completes successfully',
        () async {
      //Arrange
      when(() => _post_service.fetchData()).thenAnswer((_) async => _mockList);
      // act
      final act = await _post_service.fetchData();
      // assert
      expect(act, isA<List<PostModel>>());
      verify(() => _post_service.fetchData()).called(1);
    });
  });
}
