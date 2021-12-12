// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../flutter_atoms.dart' as _i4;
import '../navigation.dart' as _i9;
import 'blocs/boot/boot_bloc.dart' as _i11;
import 'models/compass_navigation_state.dart' as _i3;
import 'models/compass_operator.dart' as _i5;
import 'models/navigation_model.dart' as _i7;
import 'models/navigators_register.dart' as _i10;
import 'widgets/inner_router_delegate.dart' as _i8;
import 'widgets/root_navigator_observer.dart' as _i6;
import 'widgets/root_router_delegate.dart'
    as _i12; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initNavigation(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  gh.lazySingleton<_i3.CompassNavigationState>(
      () => _i3.CompassNavigationState(get<_i4.NavigationModel>()));
  gh.factoryParam<_i5.CompassOperator, String?, dynamic>((path, _) =>
      _i5.CompassOperator(path, get<_i3.CompassNavigationState>()));
  gh.factory<_i6.RootNavigatorObserver>(
      () => _i6.RootNavigatorObserver(get<_i7.NavigationModel>()));
  gh.factoryParam<_i8.InnerRouterDelegate, String?, _i9.NavBarCubit?>(
      (initialRoute, navBarCubit) => _i8.InnerRouterDelegate(
          initialRoute,
          navBarCubit,
          get<_i9.CompassNavigationState>(),
          get<_i10.NavigatorsRegister>()));
  gh.singleton<_i11.BootBloc>(_i11.BootBloc());
  gh.singleton<_i10.NavigatorsRegister>(_i10.NavigatorsRegister());
  gh.singleton<_i12.RootRouterDelegate>(_i12.RootRouterDelegate(
      get<_i9.CompassNavigationState>(),
      get<_i6.RootNavigatorObserver>(),
      get<_i10.NavigatorsRegister>()));
  return get;
}
