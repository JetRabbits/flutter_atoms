import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class StoriesCacheManager extends CacheManager {
  static StoriesCacheManager? _instance;
  static const key = "StoriesCacheManager";

  factory StoriesCacheManager() {
    if (_instance == null) {
      _instance = StoriesCacheManager._();
    }
    return _instance!;
  }

  StoriesCacheManager._() : super(Config(key, stalePeriod: Duration(hours: 1)));
}