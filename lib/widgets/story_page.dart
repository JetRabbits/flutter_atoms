import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_atoms/models/json_serializable/stories_entity.dart';
import 'package:flutter_atoms/models/json_serializable/story_item_model.dart';
import 'package:flutter_atoms/providers/cached_stories_provider.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:story_view/story_view.dart';

abstract class StoryItemBuilder {
  final StoryItemModel model;

  StoryItemBuilder(this.model);

  StoryItem build();
}

class LayeredStoryItem extends StoryItem {
  factory LayeredStoryItem.imageWithBuilder(String imageUrl, Widget secondLayer,
      {Duration duration: const Duration(seconds: 3)}) {
    print("imageUrl = $imageUrl");
    return LayeredStoryItem(
      Container(
        color: Colors.black,
        child: Stack(
          children: <Widget>[
            Center(
              child: Image(
                image: CachedNetworkImageProvider(imageUrl,
                    cacheManager: StoriesCacheManager()),
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.fitWidth,
              ),
            ),
            secondLayer
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: ElevatedButton(
            //     onPressed: () {},
            //     child: Text("test"),
            //   ),
            // )
          ],
        ),
      ),
      duration: duration,
    );
  }

  LayeredStoryItem(Widget view, {Duration duration: const Duration(seconds: 3)})
      : super(view, duration: duration);
}

class StoryPage extends StatelessWidget {
  final Color closeButtonColor;
  final Color closeButtonBackgroundColor;
  final double closeButtonElevation;

  final controller = StoryController();

  final Widget Function(dynamic json, BuildContext context)? interactiveBuilder;

  StoryPage(
      {Key? key,
      this.closeButtonColor = Colors.black,
      this.closeButtonBackgroundColor = Colors.transparent,
      this.closeButtonElevation = 0.1,
      this.interactiveBuilder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final StoriesEntity story =
        ModalRoute.of(context)!.settings.arguments as StoriesEntity;

    List<StoryItem> storyItems = story.storyItems
        .map((item) => _makeStoryItemFromUrl(item, context))
        .toList();

    return SafeArea(
        child: Scaffold(
            key: key ?? Key("story_page"),
            body: storyItems.length > 0
                ? StoryView(
                    storyItems: storyItems,
                    progressPosition: ProgressPosition.top,
                    repeat: false,
                    controller: controller)
                : Container(),
            floatingActionButton: _makeFloatingCloseButton(context)));
  }

  StoryItem _makeStoryItemFromUrl(StoryItemModel item, BuildContext context) {
    if (item.widget != null && item.widget!.length > 0) {
      return LayeredStoryItem.imageWithBuilder(
          item.imageUrl, interactiveBuilder!(item.widget, context));
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
        backgroundColor: this.closeButtonBackgroundColor,
        elevation: this.closeButtonElevation,
        mini: true,
        child: Icon(Icons.close, color: this.closeButtonColor),
        onPressed: () => Navigator.of(context).pop());
  }
}

class StoryPageArgs {
  final StoriesEntity story;

  StoryPageArgs(this.story);
}
