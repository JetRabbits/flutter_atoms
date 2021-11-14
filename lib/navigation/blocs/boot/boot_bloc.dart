import 'package:bloc/bloc.dart';
import 'package:flutter_atoms/flutter_atoms.dart';
import 'package:injectable/injectable.dart';

part 'boot_bloc_state.dart';

@singleton
class BootBloc extends Cubit<BootBlocState> {
  static final _logger = Logger('BootBloc');
  late Future<bool> Function() _onStart;

  set onStart(Future<bool> Function() value) {
    _onStart = value;
  }

  String Function()? _nextRoute;

  set nextRoute(String Function()? value) {
    _nextRoute = value;
  }

  BootBloc() : super(BootBlocState.INIT);

  @override
  // ignore: must_call_super
  void onError(Object error, StackTrace stackTrace) {
    _logger.severe("Error during application loading", error, stackTrace);
    emit(BootBlocState.ERROR);
  }

  void reset() {
    emit(BootBlocState.INIT);
  }

  Future<void> start() async {
    _logger.info("Start application loading");

    emit(BootBlocState.LOADING);
    bool result = true;
    try {
      result = await _onStart();
      _logger.info("onAppStart result ${result}");
      if (result) {
        _logger.info("Emit BootBlocState.READY");
        emit(BootBlocState.READY);
        if (_nextRoute != null) _nextRoute!().compass().replace().go();
      } else {
        _logger.info("Emit BootBlocState.ERROR");
        emit(BootBlocState.ERROR);
      }
    } catch (e, stacktrace) {
      addError(e, stacktrace);
    }
  }
}
