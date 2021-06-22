// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stories_action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoriesAction _$StoriesActionFromJson(Map<String, dynamic> json) {
  return StoriesAction(
    id: json['id'] as String,
    type: json['type'] as String,
    operation: fromJsonStoriesOperation(json['operation']),
  );
}

Map<String, dynamic> _$StoriesActionToJson(StoriesAction instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'type': instance.type,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('operation', toStoriesOperationJson(instance.operation));
  return val;
}
