import 'package:json_annotation/json_annotation.dart';

part 'stories_entity_details.g.dart';

@JsonSerializable()
class StoriesEntityDetails {
  final bool onBoarding;
  final bool turnOffStoryControl;


  StoriesEntityDetails( {this.turnOffStoryControl = false, this.onBoarding = false});

  factory StoriesEntityDetails.fromJson(Map<String, dynamic> json) =>
      _$StoriesEntityDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$StoriesEntityDetailsToJson(this);

  @override
  String toString() => toJson().toString();
}
