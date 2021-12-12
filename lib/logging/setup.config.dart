// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'constants.dart' as _i5;
import 'file_log_appender.dart' as _i3;
import 'new_file_log_appender.dart'
    as _i4; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initLogging(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final loggingModule = _$LoggingModule();
  gh.factory<Duration>(() => loggingModule.retentionCachePeriodFactory,
      instanceName: 'retentionCachePeriod');
  gh.factory<String>(() => loggingModule.logFileNameFactory,
      instanceName: 'logFile');
  gh.factory<int>(() => loggingModule.logFileSizeBytesFactory,
      instanceName: 'logFileSizeBytes');
  gh.lazySingleton<_i3.FileLogAppender>(() => _i3.FileLogAppender(
      logFile: get<String>(instanceName: 'logFile'),
      retentionCachePeriod: get<Duration>(instanceName: 'retentionCachePeriod'),
      logFileSizeBytes: get<int>(instanceName: 'logFileSizeBytes')));
  gh.singleton<_i4.FileLogAppender>(
      _i4.FileLogAppender(get<String>(instanceName: 'logFile')));
  return get;
}

class _$LoggingModule extends _i5.LoggingModule {}
