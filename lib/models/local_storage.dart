import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static final LocalStorage _instance = LocalStorage._internal();

  LocalStorage._internal();

  factory LocalStorage() {
    return _instance;
  }

  late SharedPreferences _sharedPreferences;

  late EncryptedSharedPreferences _securePreferences;

  bool hasKey(String key) {
    return _sharedPreferences.get(key) != null;
  }

  Future<void> load({String? secureKey}) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _securePreferences = await EncryptedSharedPreferences();
    var _secureKey = secureKey;
    if (_secureKey == null) {
      if (Platform.isAndroid || Platform.isFuchsia){
        _secureKey = await AndroidId().getId() ?? "Unknown ID";
      }
      else {
        var deviceInfoPlugin = DeviceInfoPlugin();
        if (Platform.isIOS) {
          _secureKey = (await deviceInfoPlugin.iosInfo).identifierForVendor;
        } else
        if (Platform.isWindows) {
          _secureKey = (await deviceInfoPlugin.windowsInfo).deviceId;
        } else
        if (Platform.isLinux) {
          _secureKey = (await deviceInfoPlugin.linuxInfo).id;
        } else
        if (Platform.isMacOS) {
          _secureKey = (await deviceInfoPlugin.macOsInfo).systemGUID;
        } else
        if (kIsWeb) {
          _secureKey = (await deviceInfoPlugin.webBrowserInfo).appCodeName;
        }
      }
    }
    _securePreferences.setEncryptionKey(_secureKey ?? "Unknown ID");
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
      return Future.value(_securePreferences.getString(key));
  }

  Future<void> secureWrite(String key, String value) async {
      await _securePreferences.setString(key, value);
  }

  Future<void> delete(String key) async {
    await _securePreferences.remove(key);
    await _sharedPreferences.remove(key);
  }

  Future<void> deleteAll() async {
    await _sharedPreferences.clear();
    await _securePreferences.clear();
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
