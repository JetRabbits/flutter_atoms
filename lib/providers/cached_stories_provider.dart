import 'dart:convert';

import 'package:flutter_atoms/models/json_serializable/stories_entity.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;


class CachedStoriesProvider {

  Map<String, StoriesEntity> _stories = <String, StoriesEntity>{};
  final String configUrl;


  CachedStoriesProvider(this.configUrl);


  Map<String, StoriesEntity> get stories => _stories;


  StoriesEntity operator [](String id) => stories[id];


  Future<void> load() async {
    stories.clear();

    try {
      final String storiesConfigJson = await _loadStoriesConfigJson();

      List<dynamic> storiesConfig = json.decode(storiesConfigJson);

      storiesConfig
          .map<StoriesEntity>((storyJson) => StoriesEntity.fromJson(storyJson))
          .forEach( (story) => stories.putIfAbsent(story.id, () => story) );

      _cacheStories();
    }
    catch (e, stacktrace) {
      print(e + stacktrace);
    }
  }


  Future<String> _loadStoriesConfigJson() async {
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

    await cacheManager.emptyCache();

    stories.values.forEach((s) {
      cacheManager.downloadFile(s.titleImage);
      s.images.forEach((i) => cacheManager.downloadFile(i));
    });
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
