import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
part 'post_model.g.dart';

// 變成 黨名.g.dart
@JsonSerializable()
class PostModel extends Equatable{
  final int userId;// json 欄位名稱
  final int id;// json 欄位名稱
  final String title;// json 欄位名稱
  final String body;// json 欄位名稱
  PostModel({required this.userId, required this.id, required this.title, required this.body});// required 裡面也要改成
  factory PostModel.fromJson(Map<String, dynamic> json) => _$PostModelFromJson(json);
  // 這裡的 PostModel.fromJson 的 PostModel 也要改動，後面的 _$PostModelFromJson 的 PostModelFromJson 也要改動
  // 變成 XXX.fromJson _$XXXFromJson
  Map<String, dynamic> toJson() => _$PostModelToJson(this);
  // 這裡的 _$PostModelToJson(this) 的 PostModel 也要改動，變成  _$XXXToJson(this)
  @override
  String toString() => "$userId $id $title $body";

  @override
  List<Object?> get props => [userId, id, title, body];
}