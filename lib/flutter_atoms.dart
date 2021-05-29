//@dart=2.9
library flutter_atoms;

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import 'flutter_atoms.config.dart';
import 'navigation/models/navigation_model.dart';

export 'package:logging/logging.dart';

export 'generated/l10n.dart';
export 'i18n/big_composite_message_lookup.dart';
export 'models/models.dart';
export 'navigation/navigation.dart';
export 'widgets/widgets.dart';

///
/// Service locator instance
///
@InjectableInit(
  initializerName: r'$initGetIt', // default
  preferRelativeImports: true, // default
  asExtension: false, // default
)
void atomsSetup(NavigationModel navigationModel) {
  GetIt.I.registerSingleton<NavigationModel>(navigationModel);
  $initGetIt(GetIt.I);
}

void setupLogging({void Function(LogRecord) onRecord, Level forceLevel}) {
  Logger.root.level = forceLevel ??
      kDebugMode ? Level.ALL : Level.WARNING;

  Logger.root.onRecord.listen(onRecord ??
      (record) {
        debugPrint(
            '${record.time} [${record.level}] [${record.loggerName}] ${record.message}\n${record.stackTrace ?? ""}');
      });
}
