import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter_atoms/logging.dart';
import 'package:flutter_atoms/stories/model/v2/stories_entity.dart';
import 'package:http/http.dart' as http;

import '../stories_cache_manager.dart';

class CachedStoriesProvider with Loggable {
  Map<String, StoriesEntity> _stories = <String, StoriesEntity>{};

  Map<String, StoriesEntity> get stories => _stories;

  StoriesEntity? get onBoardingStory {
    return _stories.values
        .firstWhereOrNull((element) => element.details?.onBoarding ?? false);
  }

  late String configUrl;

  StoriesEntity? operator [](String id) => stories[id];

  Future<void> load({String? url}) async {
    await _cleanCache();
    if (url != null) configUrl = url;

    try {
      final String storiesConfigJson = await _loadStoriesConfigJson(configUrl);

      List<dynamic> storiesConfig = json.decode(storiesConfigJson)["stories"];
        storiesConfig
            .map<StoriesEntity>(
                (storyJson) => StoriesEntity.fromJson(storyJson))
            .forEach((story) => stories.putIfAbsent(story.id, () => story));
      await _cacheStories();
    } catch (e, stacktrace) {
      logger.severe("Error during load stories", e, stacktrace);
    }
  }

  Future<void> fromJson(dynamic storiesConfig) async {
    await _cleanCache();
    try {
      (storiesConfig["stories"] as List)
          .map<StoriesEntity>((storyJson) => StoriesEntity.fromJson(storyJson))
          .forEach((story) => stories.putIfAbsent(story.id, () => story));

      await _cacheStories();
    } catch (e, stacktrace) {
      logger.severe("Error during load stories from json", e, stacktrace);
    }
  }

  Future<String> _loadStoriesConfigJson(String configUrl) async {
    final String storiesConfigUrl =
        configUrl + "?" + DateTime.now().millisecondsSinceEpoch.toString();
    logger.fine("Request: $storiesConfigUrl");

    try {
      final http.Response response =
          await http.get(Uri.parse(storiesConfigUrl));
      if (response.statusCode == 200) {
        var responseBody = utf8.decode(response.bodyBytes);
        logger.fine("Response: ${response.statusCode}: $responseBody");
        return responseBody;
      } else {
        throw Exception('Failed to load $storiesConfigUrl');
      }
    } catch (e) {
      logger.severe("Could not load $storiesConfigUrl", e);
      return "[]";
    }
  }

  Future<void> _cacheStories() async {
    final StoriesCacheManager cacheManager = StoriesCacheManager();

    stories.values.forEach((s) async {
      await cacheManager.downloadFile(s.titleImage);
      s.storyItems.forEach(
          (item) async => await cacheManager.downloadFile(item.imageUrl));
    });
  }

  Future<void> _cleanCache() async {
    if (stories.isNotEmpty) {
      stories.clear();
      final StoriesCacheManager cacheManager = StoriesCacheManager();
      return cacheManager.emptyCache();
    }
  }
}
