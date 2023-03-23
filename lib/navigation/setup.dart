import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'models/navigation_model.dart';
import 'setup.config.dart';

@InjectableInit(
  generateForDir: ['lib/navigation'],
  initializerName: r'$initNavigation', // default
  preferRelativeImports: true, // default
  asExtension: false, // default

)
void setupNavigation(NavigationModel navigationModel){
    GetIt.I.registerSingleton(navigationModel);
    $initNavigation(GetIt.I);
}
