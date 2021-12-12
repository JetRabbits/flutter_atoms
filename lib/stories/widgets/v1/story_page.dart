import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_atoms/stories/providers/stories_cache_manager.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:story_view/story_view.dart';

import '../../model/v1/stories_entity.dart';


class StoryPage extends StatelessWidget {
  final Color closeButtonColor;
  final Color closeButtonBackgroundColor;
  final double closeButtonElevation;

  final controller = StoryController();

  final StoriesEntity story;

  StoryPage({
    Key? key,
    required this.story,
    this.closeButtonColor = Colors.black,
    this.closeButtonBackgroundColor = Colors.transparent,
    this.closeButtonElevation = 0.1
  })
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    List<StoryItem> storyItems =
    story.images
        .map((url) => _makeStoryItemFromUrl(url))
        .toList();

    return SafeArea(
        child: Scaffold(
            key: key ?? Key("story_page"),
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
        backgroundColor: this.closeButtonBackgroundColor,
        elevation: this.closeButtonElevation,
        mini: true,
        child: Icon(Icons.close, color: this.closeButtonColor),
        onPressed: () => Navigator.of(context).pop()
    );
  }
}


class StoryPageArgs {
  final StoriesEntity story;

  StoryPageArgs(this.story);
}