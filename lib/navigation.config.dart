// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'navigation/blocs/boot/boot_bloc.dart' as _i11;
import 'navigation/models/compass_navigation_state.dart' as _i9;
import 'navigation/models/compass_operator.dart' as _i8;
import 'navigation/models/navigation_model.dart' as _i4;
import 'navigation/models/navigators_register.dart' as _i7;
import 'navigation/widgets/inner_router_delegate.dart' as _i10;
import 'navigation/widgets/root_navigator_observer.dart' as _i3;
import 'navigation/widgets/root_router_delegate.dart'
    as _i5; // ignore_for_file: unnecessary_lambdas
import 'navigation.dart' as _i6;

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  gh.factory<_i3.RootNavigatorObserver>(
      () => _i3.RootNavigatorObserver(get<_i4.NavigationModel>()));
  gh.factory<_i5.RootRouterDelegate>(() => _i5.RootRouterDelegate(
      get<_i6.CompassNavigationState>(),
      get<_i3.RootNavigatorObserver>(),
      get<_i7.NavigatorsRegister>()));
  gh.factoryParam<_i8.CompassOperator, String?, dynamic>((path, _) => _i8.CompassOperator(
      path, get<_i7.NavigatorsRegister>(), get<_i9.CompassNavigationState>()));
  gh.factoryParam<_i10.InnerRouterDelegate, String?, _i6.NavBarCubit?>(
      (initialRoute, navBarCubit) => _i10.InnerRouterDelegate(
          initialRoute,
          navBarCubit,
          get<_i6.CompassNavigationState>(),
          get<_i7.NavigatorsRegister>()));
  gh.singleton<_i9.CompassNavigationState>(
      _i9.CompassNavigationState(get<_i4.NavigationModel>()));
  gh.singleton<_i11.BootBloc>(_i11.BootBloc());
  gh.singleton<_i7.NavigatorsRegister>(_i7.NavigatorsRegister());
  return get;
}
