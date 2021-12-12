import 'package:injectable/injectable.dart';

@Named('retentionCachePeriod')
@Named('printLogs')

const logFileNameConst = 'app.log';
const retentionCachePeriodConst = const Duration(milliseconds: 500);
const logFileSizeBytesConst = 50000000;

@module
abstract class LoggingModule {

  @Named('logFile')
  String get logFileNameFactory => logFileNameConst;
  @Named('retentionCachePeriod')
  Duration get retentionCachePeriodFactory => retentionCachePeriodConst;
  @Named('logFileSizeBytes')
  int get logFileSizeBytesFactory => logFileSizeBytesConst;

}