import 'package:json_annotation/json_annotation.dart';

part 'story_item_model.g.dart';

@JsonSerializable()
class StoryItemModel {
  final Map<String, dynamic>? widget;
  final String imageUrl;

  StoryItemModel({required this.widget, required this.imageUrl});

  factory StoryItemModel.fromJson(Map<String, dynamic> json) =>
      _$StoryItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$StoryItemModelToJson(this);

  @override
  String toString() => toJson().toString();
}
