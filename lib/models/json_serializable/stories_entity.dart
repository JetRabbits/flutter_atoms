import 'package:json_annotation/json_annotation.dart';

part 'stories_entity.g.dart';


@JsonSerializable()
class StoriesEntity {

  final String id;
  final String? title;
  final String? titleImage;

  @JsonKey(defaultValue: [])
  final List<String>? images;


  StoriesEntity({required this.id, this.title, this.titleImage, this.images});


  factory StoriesEntity.fromJson(Map<String, dynamic> json) =>
      _$StoriesEntityFromJson(json);


  Map<String, dynamic> toJson() => _$StoriesEntityToJson(this);


  @override
  String toString() => toJson().toString();
}
