// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stories_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoriesEntity _$StoriesEntityFromJson(Map<String, dynamic> json) {
  return StoriesEntity(
    id: json['id'] as String,
    title: json['title'] as String,
    titleImage: json['title_image'] as String,
    storyItems: (json['story_items'] as List<dynamic>?)
            ?.map((e) => StoryItemModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    details:
        StoriesEntityDetails.fromJson(json['details'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$StoriesEntityToJson(StoriesEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'title_image': instance.titleImage,
      'details': instance.details.toJson(),
      'story_items': instance.storyItems.map((e) => e.toJson()).toList(),
    };