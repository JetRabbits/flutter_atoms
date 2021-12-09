import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

class VersionModel {
  /// Project Name
  String projectName = "-";

  /// Platform information
  String platform = "-";
  ///Project version name
  String projectVersion = "-";

  /// Build number
  String buildNumber = "-";

  /// Application name/label [PackageInfo.appName]
  String appName = "-";

  /// Build signature
  String buildSignature = "-";

  /// Package name [PackageInfo.packageName]
  String packageName = "-";

  Future<void> load() async {
    try {
      var deviceInfo = DeviceInfoPlugin();

      if (kIsWeb){
        platform = (await deviceInfo.webBrowserInfo).platform ?? "Web";
      } else {

        if (Platform.isAndroid){
          platform = (await deviceInfo.androidInfo).version.release ?? "Android";
        }

        if (Platform.isFuchsia){
          platform = (await deviceInfo.androidInfo).version.release ?? "Fuchsia";
        }

        if (Platform.isIOS){
          platform = (await deviceInfo.iosInfo).systemVersion ?? "IOS";
        }

        if (Platform.isLinux){
          platform = (await deviceInfo.linuxInfo).prettyName;
        }

        if (Platform.isMacOS){
          platform = (await deviceInfo.macOsInfo).kernelVersion;
        }

        if (Platform.isWindows){
          var version = (await deviceInfo.windowsInfo).computerName;
          platform = "Windows: $version";
        }
      }

    } catch (e) {
      print(e);
    }

    try {
      var packageInfo = await PackageInfo.fromPlatform();
      projectVersion = packageInfo.version;
      buildNumber = packageInfo.buildNumber;
      appName = packageInfo.appName;
      buildSignature = packageInfo.buildSignature;
      packageName = packageInfo.packageName;
    } catch (e) {
      print(e);
    }
  }

  @override
  String toString() {
    return projectVersion != "-"
        ? 'v$projectVersion (build: $buildNumber)'
        : "-";
  }
}
