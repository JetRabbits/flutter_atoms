import 'package:json_annotation/json_annotation.dart';

part 'stories_entity_details.g.dart';

@JsonSerializable()
class StoriesEntityDetails {
  @JsonKey(defaultValue: false)
  final bool onBoarding;
  @JsonKey(defaultValue: false)
  final bool turnOffStoryControl;


  StoriesEntityDetails( {this.turnOffStoryControl = false, this.onBoarding = false});

  factory StoriesEntityDetails.fromJson(Map<String, dynamic> json) =>
      _$StoriesEntityDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$StoriesEntityDetailsToJson(this);

  @override
  String toString() => toJson().toString();
}
