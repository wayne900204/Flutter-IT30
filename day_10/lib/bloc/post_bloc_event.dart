part of 'post_bloc.dart';
abstract class IPostEvent {}
/// cal Api 的事件
class FetchPostData extends IPostEvent {}
/// 排序的事件
class SortPostEvent extends IPostEvent {
  final SortState sortState;
  SortPostEvent({required this.sortState});
}
