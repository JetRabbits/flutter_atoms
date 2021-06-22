import 'package:crypted_preferences/crypted_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static final LocalStorage _instance = LocalStorage._internal();

  LocalStorage._internal();

  factory LocalStorage() {
    return _instance;
  }

  late SharedPreferences _sharedPreferences;

  late Preferences _securePreferences;

  late FlutterSecureStorage _secureStorage;

  bool hasKey(String key) {
    return _sharedPreferences.get(key) != null;
  }

  Future<void> load({webSecurePath = './secure/preferences'}) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    if (kIsWeb) {
      _securePreferences = await Preferences.preferences(path: webSecurePath);
    } else {
      _secureStorage = FlutterSecureStorage();
    }
  }

  Future<bool> setString(String key, String value) =>
      _sharedPreferences.setString(key, value);

  String getString(String key, {String value = ""}) {
    String result = value;
    try {
      result = _sharedPreferences.getString(key) ?? value;
    } catch (e) {}
    return result;
  }

  Future<String?> secureRead(String key) {
    if (kIsWeb) {
      return Future.value(_securePreferences.getString(key));
    } else {
      return _secureStorage.read(key: key);
    }
  }

  Future<void> secureWrite(String key, String value) async {
    if (kIsWeb) {
      var result = await _securePreferences.setString(key, value);
      if (!result) throw "Exception when writing preference $key";
    } else {
      return _secureStorage.write(key: key, value: value);
    }
  }

  Future<void> deleteAll() async {
    await _sharedPreferences.clear();
    if (kIsWeb) {
      await _securePreferences.clear();
    } else {
      await _secureStorage.deleteAll();
    }
  }

  Future<bool> setBool(String key, bool value) =>
      _sharedPreferences.setBool(key, value);

  bool getBool(String key, {bool value = false}) {
    bool result = value;
    try {
      result = _sharedPreferences.getBool(key) ?? value;
    } catch (e) {}
    return result;
  }

  int getInt(String key, {int value = 0}) {
    int result = value;
    try {
      result = _sharedPreferences.getInt(key) ?? value;
    } catch (e) {}
    return result;
  }

  Future<bool> setInt(String key, int value) =>
      _sharedPreferences.setInt(key, value);
}
