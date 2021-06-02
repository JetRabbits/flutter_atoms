// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'navigation/blocs/boot/boot_bloc.dart' as _i11;
import 'navigation/models/app_navigation_state.dart' as _i10;
import 'navigation/models/compass.dart' as _i9;
import 'navigation/models/navigation_model.dart' as _i6;
import 'navigation/models/navigators_register.dart' as _i8;
import 'navigation/navigation.dart' as _i4;
import 'navigation/widgets/inner_router_delegate.dart' as _i3;
import 'navigation/widgets/root_navigator_observer.dart' as _i5;
import 'navigation/widgets/root_router_delegate.dart'
    as _i7; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  gh.factoryParam<_i3.InnerRouterDelegate, String?, _i4.NavBarCubit?>(
      (initialRoute, navBarCubit) => _i3.InnerRouterDelegate(
          initialRoute,
          navBarCubit,
          get<_i4.AppNavigationState>(),
          get<_i4.NavigatorsRegister>()));
  gh.factory<_i5.RootNavigatorObserver>(
      () => _i5.RootNavigatorObserver(get<_i6.NavigationModel>()));
  gh.factory<_i7.RootRouterDelegate>(() => _i7.RootRouterDelegate(
      get<_i4.AppNavigationState>(),
      get<_i5.RootNavigatorObserver>(),
      get<_i8.NavigatorsRegister>()));
  gh.factoryParam<_i9.Compass, String?, dynamic>((path, _) => _i9.Compass(
      path, get<_i8.NavigatorsRegister>(), get<_i10.AppNavigationState>()));
  gh.singleton<_i10.AppNavigationState>(
      _i10.AppNavigationState(get<_i6.NavigationModel>()));
  gh.singleton<_i11.BootBloc>(_i11.BootBloc());
  gh.singleton<_i8.NavigatorsRegister>(_i8.NavigatorsRegister());
  return get;
}
