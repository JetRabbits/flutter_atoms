// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../flutter_atoms.dart' as _i5;
import '../navigation.dart' as _i8;
import 'blocs/boot/boot_bloc.dart' as _i3;
import 'blocs/navigator/nav_bar_cubit.dart' as _i10;
import 'models/compass_navigation_state.dart' as _i4;
import 'models/compass_operator.dart' as _i6;
import 'models/navigation_model.dart' as _i13;
import 'models/navigators_register.dart' as _i11;
import 'observers/inner_navigation_observer.dart' as _i7;
import 'observers/root_navigator_observer.dart' as _i12;
import 'widgets/inner_router_delegate.dart' as _i9;
import 'widgets/root_router_delegate.dart'
    as _i14; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initNavigation(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  gh.singleton<_i3.BootBloc>(_i3.BootBloc());
  gh.lazySingleton<_i4.CompassNavigationState>(
      () => _i4.CompassNavigationState(get<_i5.NavigationModel>()));
  gh.factoryParam<_i6.CompassOperator, String?, dynamic>((path, _) =>
      _i6.CompassOperator(path, get<_i4.CompassNavigationState>()));
  gh.factoryParam<_i7.InnerNavigatorObserver, _i8.NavBarCubit?, dynamic>(
      (navbarCubit, _) => _i7.InnerNavigatorObserver(navbarCubit));
  gh.factory<_i9.InnerRouterDelegate>(() => _i9.InnerRouterDelegate());
  gh.factoryParam<_i10.NavBarCubit, String?, dynamic>(
      (initPath, _) => _i10.NavBarCubit(initPath));
  gh.singleton<_i11.NavigatorsRegister>(_i11.NavigatorsRegister());
  gh.factory<_i12.RootNavigatorObserver>(
      () => _i12.RootNavigatorObserver(get<_i13.NavigationModel>()));
  gh.factory<_i14.RootRouterDelegate>(() => _i14.RootRouterDelegate(
      get<_i8.CompassNavigationState>(), get<_i12.RootNavigatorObserver>()));
  return get;
}
