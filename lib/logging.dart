library logging;

import 'package:flutter/foundation.dart';
import 'package:flutter_atoms/logging/file_log_appender.dart';
import 'package:logging/logging.dart';

export 'logging/file_log_appender.dart';
export 'logging/send_bug_report.dart';

void setupLogging({void Function(LogRecord)? onRecord, Level? forceLevel}) {
  Logger.root.level = forceLevel ?? (kDebugMode ? Level.ALL : Level.WARNING);
  Logger.root.onRecord.listen(onRecord ??
      (record) {
        var tail = "";
        if (record.error != null) tail+= ": ${record.error}";
        if (record.stackTrace != null) tail+= "\n${record.stackTrace}";
        debugPrint(
            '${record.time} [${record.level}] [${record.loggerName}] ${record.message}$tail', wrapWidth: 1000);
      });
}

var fileLogAppender;

void setupLoggingWithLogfile(
    {String logfile: 'error.log',
    bool printToConsole: true,
    Level? forceLevel}) {
  Logger.root.level = forceLevel ?? (kDebugMode ? Level.ALL : Level.WARNING);
  fileLogAppender = FileLogAppender(logfile);
  Logger.root.onRecord.listen((record) {
    var tail = "";
    if (record.error != null) tail+= ": ${record.error}";
    if (record.stackTrace != null) tail+= "\n${record.stackTrace}";
    var s =
        '${record.time} [${record.level}] [${record.loggerName}] ${record.message}$tail';
    fileLogAppender.append(s);
    if (printToConsole) debugPrint(s, wrapWidth: 1000);
  });
}
