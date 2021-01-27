import 'dart:convert';

import 'package:flutter_atoms/models/json_serializable/stories_entity.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;


class CachedStoriesProvider {

  Map<String, StoriesEntity> _stories = <String, StoriesEntity>{};


  Map<String, StoriesEntity> get stories => _stories;


  StoriesEntity operator [](String id) => stories[id];


  Future<void> load(String configUrl) async {
    await _cleanCache();

    try {
      final String storiesConfigJson = await _loadStoriesConfigJson(configUrl);

      List<dynamic> storiesConfig = json.decode(storiesConfigJson);

      storiesConfig
          .map<StoriesEntity>((storyJson) => StoriesEntity.fromJson(storyJson))
          .forEach( (story) => stories.putIfAbsent(story.id, () => story) );

      await _cacheStories();
    }
    catch (e, stacktrace) {
      print(e + stacktrace);
    }
  }


  Future<String> _loadStoriesConfigJson(String configUrl) async {
    final String storiesConfigUrl =
        configUrl + "?" + DateTime.now().millisecondsSinceEpoch.toString();
    print("Request: $storiesConfigUrl");

    try {
      final http.Response response = await http.get(storiesConfigUrl);
      if (response.statusCode == 200) {
        var responseBody = utf8.decode(response.bodyBytes);
        print("Response: ${response.statusCode}: $responseBody");
        return responseBody;
      } else {
        throw Exception('Failed to load $storiesConfigUrl');
      }
    } catch (e) {
      print("Could not load $storiesConfigUrl: $e");
      return "[]";
    }
  }


  Future<void> _cacheStories() async {
    final StoriesCacheManager cacheManager = StoriesCacheManager();

    stories.values.forEach((s) async {
      await cacheManager.downloadFile(s.titleImage);
      s.images.forEach((i) async => await cacheManager.downloadFile(i));
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


class StoriesCacheManager extends CacheManager {

  static StoriesCacheManager _instance;
  static const key = "StoriesCacheManager";


  factory StoriesCacheManager() {
    if (_instance == null) {
      _instance = StoriesCacheManager._();
    }
    return _instance;
  }


  StoriesCacheManager._() : super(Config(key, stalePeriod: Duration(hours: 1)));
}
