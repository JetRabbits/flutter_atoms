// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stories_entity_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoriesEntityDetails _$StoriesEntityDetailsFromJson(
        Map<String, dynamic> json) =>
    StoriesEntityDetails(
      turnOffStoryControl: json['turn_off_story_control'] as bool? ?? false,
      onBoarding: json['on_boarding'] as bool? ?? false,
    );

Map<String, dynamic> _$StoriesEntityDetailsToJson(
        StoriesEntityDetails instance) =>
    <String, dynamic>{
      'on_boarding': instance.onBoarding,
      'turn_off_story_control': instance.turnOffStoryControl,
    };
