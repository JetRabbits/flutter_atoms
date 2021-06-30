//@dart=2.9
library flutter_atoms;

import 'package:flutter/foundation.dart';
import 'package:flutter_atoms/stories.dart';
import 'package:flutter_draft/flutter_draft.dart';
import 'package:logging/logging.dart';

export 'package:logging/logging.dart';

export 'generated/l10n.dart';
export 'i18n/big_composite_message_lookup.dart';
export 'models/models.dart';
export 'navigation.dart';

void setupAtoms() {
  ActionRegister.addAction(
      'stories', StoriesAction.toJson, StoriesAction.fromJson);
}

void setupLogging({void Function(LogRecord) onRecord, Level forceLevel}) {
  Logger.root.level = forceLevel ?? kDebugMode ? Level.ALL : Level.WARNING;

  Logger.root.onRecord.listen(onRecord ??
      (record) {
        print(
            '${record.time} [${record.level}] [${record.loggerName}] ${record.message}\n${record.stackTrace ?? ""}');
      });
}
