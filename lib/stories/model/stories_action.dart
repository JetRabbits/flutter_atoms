import 'package:flutter/widgets.dart' show Navigator;
import 'package:flutter_atoms/stories/widgets/story_page.dart';
import 'package:flutter_draft/flutter_draft.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:logging/logging.dart';

part 'stories_action.g.dart';

enum StoriesOperation { FORWARD, BACKWARD, CLOSE }

dynamic toStoriesOperationJson(StoriesOperation operation) {
  return operation.toString().replaceAll(operation.runtimeType.toString(), "").toLowerCase();
}

StoriesOperation fromJsonStoriesOperation(dynamic json) {
  return StoriesOperation.values
      .where((element) => toStoriesOperationJson(element).contains(json.toString()))
      .first;
}

@JsonSerializable()
class StoriesAction extends Action {
  @JsonKey(fromJson: fromJsonStoriesOperation, toJson: toStoriesOperationJson)
  final StoriesOperation operation;

  StoriesAction(
      {required String id,
      String type = 'stories',
      this.operation = StoriesOperation.FORWARD})
      : super(type: type, id: id);

  static Map<String, dynamic> toJson(Action instance) =>
      _$StoriesActionToJson(instance as StoriesAction);

  static Action fromJson(dynamic json) => _$StoriesActionFromJson(json);
  static final _logger = Logger('StoriesAction');

  @override
  Future<void> perform(BuildContext context, Map<String, dynamic> parameters) async {
    var state = StoryPageState.of(context);
    if (state != null){
      switch(operation){
        case StoriesOperation.FORWARD:
          _logger.info('forward');
          state.controller.next();
          return;
        case StoriesOperation.BACKWARD:
          _logger.info('backward');
          state.controller.previous();
          return;
        case StoriesOperation.CLOSE:
          _logger.info('close');
          Navigator.of(context).pop();
          return;
      }
    }
  }
}
