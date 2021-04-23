// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stories_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoriesEntity _$StoriesEntityFromJson(Map<String, dynamic> json) {
  return StoriesEntity(
    id: json['id'] as String,
    title: json['title'] as String?,
    titleImage: json['title_image'] as String?,
    images: (json['images'] as List?)?.map((e) => e as String).toList() ?? [],
  );
}

Map<String, dynamic> _$StoriesEntityToJson(StoriesEntity instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('title', instance.title);
  writeNotNull('title_image', instance.titleImage);
  writeNotNull('images', instance.images);
  return val;
}
