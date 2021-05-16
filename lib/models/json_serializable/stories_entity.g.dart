// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stories_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoriesEntity _$StoriesEntityFromJson(Map<String, dynamic> json) {
  return StoriesEntity(
    id: json['id'] as String,
    title: json['title'] as String?,
    titleImage: json['titleImage'] as String?,
    images:
        (json['images'] as List<dynamic>?)?.map((e) => e as String).toList() ??
            [],
  );
}

Map<String, dynamic> _$StoriesEntityToJson(StoriesEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'titleImage': instance.titleImage,
      'images': instance.images,
    };
