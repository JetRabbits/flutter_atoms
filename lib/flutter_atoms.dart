library flutter_atoms;

import 'package:flutter_atoms/stories.dart';
import 'package:flutter_draft/flutter_draft.dart';

export 'package:logging/logging.dart';

export 'generated/l10n.dart';
export 'i18n/big_composite_message_lookup.dart';
export 'navigation.dart';

void setupAtoms() {
  ActionRegister.addAction(
      'stories', StoriesAction.toJson, StoriesAction.fromJson);
}
