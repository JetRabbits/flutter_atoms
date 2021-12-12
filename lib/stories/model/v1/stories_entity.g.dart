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
    images:
        (json['images'] as List<dynamic>?)?.map((e) => e as String).toList() ??
            [],
    details: json['details'] == null
        ? null
        : StoriesEntityDetails.fromJson(
            json['details'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$StoriesEntityToJson(StoriesEntity instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'title': instance.title,
    'title_image': instance.titleImage,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('details', instance.details?.toJson());
  val['images'] = instance.images;
  return val;
}
