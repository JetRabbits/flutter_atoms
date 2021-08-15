import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileLogAppender {
  final String logFile;
  List<String> _recordsCache = [];
  Timer? _timer;
  bool _fileValidated = false;
  bool _fileValidationResult = false;

  File? _file;

  final bool printLogs;

  final Duration retentionCachePeriod;

  final int logFileSizeBytes;

  FileLogAppender(this.logFile,  {this.retentionCachePeriod: const Duration(milliseconds: 500), this.logFileSizeBytes: 50000000, this.printLogs: false}) {
    assert(logFile.isNotEmpty, "logFile should not be empty");
    _createLogFile();
  }

  Future<bool> append(String record) async {
    _recordsCache.add(record);

    if (_timer != null) {
      _timer?.cancel();
    }
    _timer = Timer(retentionCachePeriod, () => _processCache());

    return true;
  }

  Future<void> _processCache() async {
    try {
      if (!_fileValidated) {
        _fileValidationResult = await _createLogFile();
        _fileValidated = true;
      }
      var _list = _recordsCache.toList();
      _list.forEach((r) async => await _processRecord(r));
      _recordsCache.removeRange(0, _list.length);
    } catch (exc, stackTrace) {
      _printLog("Exception occurred: $exc stack: $stackTrace");
    }
  }

  Future<bool> _processRecord(String record) async {
    if (_fileValidationResult) {
      var sink = _openFileForAppend();

      try {
        _writeReportToFile(record, sink);
      } catch (e) {
        _printLog(e.toString());
      } finally {
        await _closeFile(sink);
      }
      return true;
    } else {
      return false;
    }
  }

  Future<bool> _createLogFile() async {
    try {
      if (_file == null) {
        var directory = await getApplicationDocumentsDirectory();
        _file = File("${directory.path}/$logFile");
      }
      bool exists = await _file!.exists();
      if (!exists) {
        _file!.createSync();
      } else if (_file!.lengthSync() > logFileSizeBytes) {
        _file!.deleteSync();
        _file!.createSync();
      }
      IOSink sink = _file!.openWrite(mode: FileMode.append);
      sink.write("");
      await sink.flush();
      await sink.close();
      return true;
    } catch (exc, stackTrace) {
      _printLog("Exception occurred during check log file: $exc stacktrace: $stackTrace");
      return false;
    }
  }

  IOSink _openFileForAppend() {
    return _file!.openWrite(mode: FileMode.append);
  }

  void _writeLineToFile(String text, IOSink sink) {
    try {
      sink.add(utf8.encode('$text\n'));
    } catch (e) {}
  }

  Future<void> _closeFile(IOSink sink) async {
    try {
      sink.flush();
      sink.close();
    } catch (e) {}
    _printLog("Error during close file $_file");
  }

  Future<void> _writeReportToFile(String report, IOSink sink) async {
    _printLog("Writing report to file");
    _writeLineToFile(report, sink);
  }

  void _printLog(String log) {
    if (printLogs) {
      print(log);
    }
  }
}
