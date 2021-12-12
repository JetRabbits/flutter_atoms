import 'dart:async';
import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

@singleton
class FileLogAppender {
  final String logFile;
  List<String> _recordsCache = [];
  Timer? _timer;
  File? _file;

  bool printLogs = false;
  Duration retentionCachePeriod = const Duration(milliseconds: 500);
  int logFileSizeBytes = 50000000;

  FileLogAppender(@Named('logFile') this.logFile) {
    assert(logFile.isNotEmpty, "logFile should not be empty");
    _ensureLogFile();
  }

  void append(String record) async {
    _recordsCache.add(record);

    if (_timer != null) {
      _timer?.cancel();
    }
    _timer = Timer(retentionCachePeriod, () => _processCache());
  }

  Future<void> _processCache() async {
    try {
      await _ensureLogFile();
      var _list = _recordsCache.toList();
      _list.forEach((r) async => await _processRecord(r));
      _recordsCache.removeRange(0, _list.length);
    } catch (exc, stackTrace) {
      _printLog("Exception occurred: $exc stack: $stackTrace");
    }
  }

  Future<bool> _processRecord(String record) async {
    if (_file != null) {
      try {
        _writeReportToFile(record);
        _printLog(record);
        return true;
      } catch (e) {
        print(e);
      }
    }
    return false;
  }

  Future<bool> _ensureLogFile() async {
    try {
      if (_file == null) {
        var directory = await getApplicationDocumentsDirectory();
        _file = File("${directory.path}/$logFile");
      }
      bool exists = _file!.existsSync();
      if (!exists) {
        _file!.createSync();
      } else if (_file!.lengthSync() > logFileSizeBytes) {
        _file!.deleteSync();
        _file!.createSync();
      }
      return true;
    } catch (exc, stackTrace) {
      _printLog(
          "Exception occurred during check log file: $exc stacktrace: $stackTrace");
      return false;
    }
  }

  void _writeLineToFile(String text) {
    _file?.writeAsStringSync('$text\n', mode: FileMode.append, flush: true);
  }

  Future<void> _writeReportToFile(String report) async {
    //_printLog("Writing report to file");
    _writeLineToFile(report);
  }

  void _printLog(String log) {
    if (printLogs) {
      print(log);
    }
  }

}
