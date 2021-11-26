import 'package:bloc/bloc.dart';
import 'package:flutter_atoms/flutter_atoms.dart';
import 'package:flutter_atoms/logging.dart';
import 'package:injectable/injectable.dart';

part 'boot_bloc_state.dart';

@singleton
class BootBloc extends Cubit<BootBlocState> with Loggable {
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
    logger.severe("Error during application loading", error, stackTrace);
    emit(BootBlocState.ERROR);
  }

  void reset() {
    emit(BootBlocState.INIT);
  }

  Future<void> start() async {
    logger.info("Start application loading");

    emit(BootBlocState.LOADING);
    bool result = true;
    try {
      result = await _onStart();
      logger.finest("onAppStart result $result");
      if (result) {
        logger.finest("Emit BootBlocState.READY");
        emit(BootBlocState.READY);
        if (_nextRoute != null) _nextRoute!().compass().replace().go();
      } else {
        logger.finest("Emit BootBlocState.ERROR");
        emit(BootBlocState.ERROR);
      }
    } catch (e, stacktrace) {
      addError(e, stacktrace);
    }
  }
}
