import 'package:logging/logging.dart';

mixin Loggable {
  Logger? _logger;
  Logger get logger => _logger ?? (_logger = Logger(this.runtimeType.toString()));
}