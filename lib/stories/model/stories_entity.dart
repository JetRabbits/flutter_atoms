import 'package:json_annotation/json_annotation.dart';

import 'stories_entity_details.dart';
import 'story_item_model.dart';

part 'stories_entity.g.dart';

@JsonSerializable()
class StoriesEntity {
  final String id;
  final String title;
  final String titleImage;
  final StoriesEntityDetails details;

  @JsonKey(defaultValue: [])
  final List<StoryItemModel> storyItems;

  StoriesEntity(
      {required this.id,
      required this.title,
      required this.titleImage,
      required this.storyItems,
      required this.details});

  factory StoriesEntity.fromJson(Map<String, dynamic> json) =>
      _$StoriesEntityFromJson(json);

  Map<String, dynamic> toJson() => _$StoriesEntityToJson(this);

  @override
  String toString() => toJson().toString();
}
