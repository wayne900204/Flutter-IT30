part of 'post_cubit.dart';
abstract class IPostState {}

class PostLoading extends IPostState {}

class PostSuccess extends IPostState {
  final List<PostModel> postList;
  PostSuccess( this.postList);
}
