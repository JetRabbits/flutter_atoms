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
      if (result)
        emit(BootBlocState.READY);
      else
        emit(BootBlocState.ERROR);
    } catch (e, stacktrace) {
      addError(e, stacktrace);
    }
  }
}
