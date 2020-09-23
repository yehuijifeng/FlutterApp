import 'package:json_annotation/json_annotation.dart';

part 'Posts.g.dart';

//这个标注是告诉生成器，这个类是需要生成Model类的
// flutter packages pub run build_runner build ；build 一次性构建代码
// flutter packages pub run build_runner watch 自动构建代码
@JsonSerializable()
class Posts {
  int userId;
  int id;
  String title;
  String body;

  Posts(this.userId, this.id, this.title, this.body);

  //不同的类使用不同的mixin即可
  factory Posts.fromJson(Map<String, dynamic> json) => _$PostsFromJson(json);

  Map<String, dynamic> toJson() => _$PostsToJson(this);
}
