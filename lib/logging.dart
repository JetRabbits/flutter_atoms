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
        print(
            '${record.time} [${record.level}] [${record.loggerName}] ${record.message}\n${record.stackTrace ?? ""}');
      });
}

var fileLogAppender;

void setupLoggingWithLogfile({String logfile: 'error.log', bool printToConsole: true, Level? forceLevel}) {
  Logger.root.level = forceLevel ?? (kDebugMode ? Level.ALL : Level.WARNING);
  fileLogAppender = FileLogAppender(logfile);
  Logger.root.onRecord.listen(
          (record) {
        fileLogAppender.append('${record.time} [${record.level}] [${record.loggerName}] ${record.message}\n${record.stackTrace ?? ""}');
        if (printToConsole) debugPrint(
            '${record.time} [${record.level}] [${record.loggerName}] ${record.message}\n${record.stackTrace ?? ""}', wrapWidth: 100);
      });
}
