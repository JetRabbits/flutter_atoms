// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryItemModel _$StoryItemModelFromJson(Map<String, dynamic> json) {
  return StoryItemModel(
    widget: json['widget'] as Map<String, dynamic>?,
    imageUrl: json['image_url'] as String,
  );
}

Map<String, dynamic> _$StoryItemModelToJson(StoryItemModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('widget', instance.widget);
  val['image_url'] = instance.imageUrl;
  return val;
}
