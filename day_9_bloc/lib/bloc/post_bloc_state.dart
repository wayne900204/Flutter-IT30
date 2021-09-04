part of 'post_bloc.dart';
abstract class IPostState {
}
/// Loading 狀態
class PostLoading extends IPostState {}
/// 成功的狀態
class PostSuccess extends IPostState {
  final List<PostModel> postList;

  PostSuccess( this.postList);
}
