
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import 'file_log_appender.dart';
import 'setup.config.dart';

@InjectableInit(
  generateForDir: ['lib/logging'],
  initializerName: r'$initLogging', // default
  preferRelativeImports: true, // default
  asExtension: false, // default
)
void setupCustomLogging({void Function(LogRecord)? onRecord, Level? forceLevel}) {
  $initLogging(GetIt.I);
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

void setupLoggingWithLogfile(
    {bool printToConsole = true,
      Level? forceLevel}) {
  $initLogging(GetIt.I);
  var fileLogAppender = GetIt.I<FileLogAppender>();
  Logger.root.level = forceLevel ?? (kDebugMode ? Level.ALL : Level.WARNING);
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
