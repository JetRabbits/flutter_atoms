import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_atoms/stories/model/stories_entity.dart';
import 'package:flutter_atoms/stories/model/story_item_model.dart';
import 'package:flutter_atoms/stories/providers/cached_stories_provider.dart';
import 'package:flutter_atoms/stories/widgets/interactive_story_view.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:story_view/story_view.dart';

abstract class StoryItemBuilder {
  final StoryItemModel model;

  StoryItemBuilder(this.model);

  StoryItem build();
}

class InteractiveStoryItem extends StoryItem {
  final WidgetBuilder interactiveLayer;

  InteractiveStoryItem(Widget view, this.interactiveLayer,
      {Duration duration: const Duration(seconds: 3)})
      : super(view, duration: duration);
}

class StoryPage extends StatefulWidget {
  final Color closeButtonColor;
  final Color closeButtonBackgroundColor;
  final double closeButtonElevation;

  final Widget Function(dynamic json, BuildContext context)? interactiveBuilder;

  final StoriesEntity story;

  final Function(int index)? onStoryItemShow;

  final Function(StoriesEntity story)? onStoryClose;

  StoryPage(
      {Key? key,
      required this.story,
      this.closeButtonColor = Colors.black,
      this.closeButtonBackgroundColor = Colors.transparent,
      this.closeButtonElevation = 0.1,
      this.onStoryItemShow,
      this.onStoryClose,
      this.interactiveBuilder})
      : super(key: key);

  @override
  StoryPageState createState() => StoryPageState();
}

class StoryPageState extends State<StoryPage> {
  final StoryController controller = StoryController();
  List<StoryItem> _storyItems = [];

  static StoryPageState? of(BuildContext context) =>
      context.findAncestorStateOfType<StoryPageState>();

  @override
  void initState() {
    super.initState();
    _storyItems = widget.story.storyItems
        .map((item) => _makeStoryItemFromUrl(item, context))
        .toList();
    // controller.play();
    //
    // if (widget.story.storyItems.firstWhereOrNull((element) => element.widget != null && element.widget!.isNotEmpty) != null){
    //   controller.pause();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          key: widget.key ?? Key("story_page"),
          body: _storyItems.length > 0
              ? InteractiveStoryView(
                  storyItems: _storyItems,
                  progressPosition: ProgressPosition.top,
                  repeat: false,
                  onStoryShow: widget.onStoryItemShow != null
                      ? (storyItem) => widget
                          .onStoryItemShow!(_storyItems.indexOf(storyItem))
                      : null,
                  canControl:
                      !(widget.story.details?.turnOffStoryControl ?? false),
                  controller: controller)
              : Container(),
          floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
          floatingActionButton: _makeFloatingCloseButton(context)),
    );
  }

  StoryItem _makeStoryItemFromUrl(StoryItemModel item, BuildContext context) {
    if (item.widget != null && item.widget!.length > 0) {
      return InteractiveStoryItem(
          Container(
            color: Colors.black,
            child: Stack(
              children: <Widget>[
                Center(
                  child: Image(
                    image: CachedNetworkImageProvider(item.imageUrl,
                        cacheManager: StoriesCacheManager()),
                    height: double.infinity,
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ],
            ),
          ),
          (context) => widget.interactiveBuilder!(item.widget, context),
          duration: Duration(hours: 24));
    } else {
      return StoryItem.pageProviderImage(
          CachedNetworkImageProvider(item.imageUrl,
              cacheManager: StoriesCacheManager()),
          duration: Duration(seconds: 15),
          imageFit: BoxFit.fitHeight);
    }
  }

  Widget _makeFloatingCloseButton(BuildContext context) {
    return FloatingActionButton(
        backgroundColor: this.widget.closeButtonBackgroundColor,
        elevation: this.widget.closeButtonElevation,
        mini: true,
        child: Icon(Icons.close, color: this.widget.closeButtonColor),
        onPressed: () {
          if (widget.onStoryClose != null) widget.onStoryClose!(widget.story);
          Navigator.of(context).pop();
        });
  }
}

class StoryPageArgs {
  final StoriesEntity story;

  StoryPageArgs(this.story);
}
