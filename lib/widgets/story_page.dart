import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_atoms/models/json_serializable/stories_entity.dart';
import 'package:flutter_atoms/providers/cached_stories_provider.dart';
import 'package:story_view/story_view.dart';


class StoryPage extends StatelessWidget {

  final controller = StoryController();


  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context).settings.arguments as StoryPageArgs;
    final StoriesEntity story = args.story;

    List<StoryItem> storyItems =
      story.images
          .map((url) => _makeStoryItemFromUrl(url))
          .toList();

    return SafeArea(
      child: Scaffold(
        key: Key("story_page"),
        body: storyItems.length > 0
            ? StoryView(
                storyItems: storyItems,
                progressPosition: ProgressPosition.top,
                repeat: false,
                controller: controller
              )
            : Container(),
        floatingActionButton: _makeFloatingCloseButton(context)
      )
    );
  }


  StoryItem _makeStoryItemFromUrl(String url) {
    return StoryItem.pageProviderImage(
      CachedNetworkImageProvider(url, cacheManager: StoriesCacheManager()),
      duration: Duration(seconds: 15),
      imageFit: BoxFit.fitHeight
    );
  }


  Widget _makeFloatingCloseButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.transparent,
      elevation: 0.1,
      mini: true,
      child: Icon(Icons.close),
      onPressed: () => Navigator.of(context).pop()
    );
  }
}


class StoryPageArgs {
  final StoriesEntity story;

  StoryPageArgs(this.story);
}