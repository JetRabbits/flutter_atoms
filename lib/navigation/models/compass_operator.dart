import '../exceptions/no_route_found.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import 'compass_navigation_state.dart';
import 'navigators_register.dart';

CompassOperator get compass => GetIt.I<CompassOperator>();

///
/// Manipulates navigator history
///
@injectable
class CompassOperator {
  static final _logger = Logger('CompassOperator');
  final NavigatorsRegister navigatorsRegistry;
  final CompassNavigationState state;
  late String path;

  HistoryData get _historyData =>
      state.historyData.lastWhere((element) => element.path == path);

  Map<String, dynamic> get data => _historyData.params;

  bool _root = false;
  bool _replace = false;

  bool _clear = false;
  bool _switchOn = false;

  CompassOperator(
      @factoryParam String? path, this.navigatorsRegistry, this.state) {
    this.path = path ?? state.currentRoute;
  }

  CompassOperator root() {
    _root = true;
    return this;
  }

  CompassOperator replace() {
    _replace = true;
    return this;
  }

  CompassOperator switchOn() {
    _switchOn = true;
    return this;
  }

  CompassOperator clear() {
    _clear = true;
    return this;
  }

  void back([dynamic data]) {
    _pop(_historyData, data);
    state.update();
  }

  Future<T?> go<T>([Map<String, dynamic>? params]) async {
    _logger.info("go to path $path, replace = $_replace, use root = $_root");
    // var rootNavigator = navigatorsRegistry.getRoot().currentState;
    // if (rootNavigator == null) return Future.value(null);
    // var _currentPagePath = appNavigationState.currentPage.path;
    // log("currentPagePath $_currentPagePath", name: loggerName);
    // var _nextPagePath =
    //     appNavigationState.navigationModel.getPageByRoute(path!).path;
    // log("nextPagePath $_nextPagePath", name: loggerName);
    // NavigatorState? _operationNavigator;
    // if (_currentPagePath == _nextPagePath) {
    //   log("_currentPagePath == _nextPagePath", name: loggerName);
    //   _operationNavigator =
    //       navigatorsRegistry.get(_currentPagePath!).currentState;
    // } else {
    //   log("using root navigator", name: loggerName);
    //   _operationNavigator = rootNavigator;
    // }
    if (_clear) state.historyData.clear();

    HistoryData<T?> result;

    if (_switchOn) {
      state.historyData.remove(path);
      result = _push(path, params ?? {});
    } else if (_replace) {
      _pop(state.historyData.last);
      result = _push(path, params ?? {});
    } else {
      result = _push(path, params ?? {});
    }
    state.update();
    return result.routeCompleter.future;
  }

  HistoryData<T?> _push<T>(String route, Map<String, dynamic> params) {
    HistoryData<T?> historyData;
    try {
      var validatedRoute =
          state.navigationModel.routesValidator.validate(route);
      state.navigationModel.getScreenByRoute(validatedRoute);
      var _paramsInPath = state.navigationModel
          .getParametersFromRoute(route)
          .cast<String, dynamic>();
      historyData = HistoryData<T?>(
          path: validatedRoute,
          params: Map<String, dynamic>()
            ..addAll(_paramsInPath)
            ..addAll(params));
      state.historyData.add(historyData);
    } catch (e, stacktrace) {
      _logger.severe("Error during navigation", e, stacktrace);
      if (e is NoRouteFoundException) {
        historyData = HistoryData(path: '/404');
        state.historyData.add(historyData);
      } else {
        historyData = HistoryData(path: '/error');
        state.historyData.add(historyData);
      }
    }
    return historyData;
  }

  void _pop(HistoryData target, [dynamic data]) {
    target.result = data;
    target.routeCompleter.complete(data);
    state.historyData.remove(target);
  }
}
