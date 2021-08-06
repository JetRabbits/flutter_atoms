library navigation;

import 'package:flutter_atoms/flutter_atoms.dart';
import 'package:flutter_atoms/navigation.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

export 'navigation/blocs/navigator/nav_bar_cubit.dart';
export 'navigation/extensions/routes.dart';
export 'navigation/models/button_config.dart';
export 'navigation/models/compass_navigation_state.dart';
export 'navigation/models/compass_operator.dart';
export 'navigation/models/float_action_button_config.dart';
export 'navigation/models/navigation_model.dart';
export 'navigation/models/navigation_page.dart';
export 'navigation/models/navigation_screen.dart';
export 'navigation/models/navigator_observer.dart';
export 'navigation/models/navigators_register.dart';
export 'navigation/models/screen_group.dart';
export 'navigation/widgets/boot_screen.dart';
export 'navigation/widgets/jet_app.dart';
export 'navigation/widgets/jet_page.dart';

@InjectableInit(
  initializerName: r'$initGetIt', // default
  preferRelativeImports: true, // default
  asExtension: false, // default
)
void setupNavigation(NavigationModel navigationModel){
  GetIt.I.registerSingleton(navigationModel);
  $initGetIt(GetIt.I);
}

