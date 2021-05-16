//@dart=2.9
library flutter_atoms;


export 'generated/l10n.dart';
export 'i18n/big_composite_message_lookup.dart';
export 'models/models.dart';
export 'navigation/navigation.dart';
export 'widgets/widgets.dart';
export 'package:logging/logging.dart';

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'flutter_atoms.config.dart';
///
/// Service locator instance
///
@InjectableInit(
  initializerName: r'$initGetIt', // default
  preferRelativeImports: true, // default
  asExtension: false, // default
)
void atomsSetup() => $initGetIt(GetIt.I);
