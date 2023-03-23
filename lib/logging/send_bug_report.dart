import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:flutter_atoms/logging/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

Future<void> sendLog({String errorLog = logFileNameConst}) async {
  var directory = await getApplicationDocumentsDirectory();
  var _file = File("${directory.path}/$errorLog");
  // Zip a directory to out.zip using the zipDirectory convenience method
  var encoder = ZipFileEncoder();
  var zipFileName = "$errorLog.zip";
  var zipPath = "${directory.path}/$zipFileName";
  File zipFile = File(zipPath);
  if (zipFile.existsSync()) {
    zipFile.deleteSync();
  }
  encoder.create(zipPath);
  encoder.addFile(_file);
  encoder.close();
  if (zipFile.existsSync()) {
    await Share.shareXFiles([XFile(zipPath)], subject: 'Error log',
        text: 'Error log');
  }
}
