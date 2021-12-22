import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

mixin DeviceInfoPrinter {
  Future<void> addDeviceInfo(File file) async {
    late BaseDeviceInfo deviceInfo;
    if (Platform.isAndroid) {
      deviceInfo = await DeviceInfoPlugin().androidInfo;
    } else
    if (Platform.isIOS) {
      deviceInfo = await DeviceInfoPlugin().iosInfo;
    } else
    if (Platform.isWindows) {
      deviceInfo = await DeviceInfoPlugin().windowsInfo;
    } else
    if (Platform.isMacOS) {
      deviceInfo = await DeviceInfoPlugin().macOsInfo;
    } else
    if (Platform.isLinux) {
      deviceInfo = await DeviceInfoPlugin().linuxInfo;
    } else
    if (Platform.isFuchsia) {
      deviceInfo = await DeviceInfoPlugin().androidInfo;
    }
    if (kIsWeb) {
      deviceInfo = await DeviceInfoPlugin().webBrowserInfo;
    }
    file.writeAsStringSync(deviceInfo.toMap().toString());
  }
}
