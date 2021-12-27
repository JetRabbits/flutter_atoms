import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

mixin DeviceInfoPrinter {
  Future<void> addDeviceInfo(File file) async {
    BaseDeviceInfo deviceInfo = await DeviceInfoPlugin().deviceInfo;
    var deviceMap = deviceInfo.toMap();
    var info = deviceMap.keys
        .map<String>((key) => "$key: ${deviceMap[key]}")
        .toList()
        .join("\n");
    file.writeAsStringSync('''
******************
$info
******************
''');
  }
}
