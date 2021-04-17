import 'package:bloc/bloc.dart';

part 'boot_bloc_state.dart';

class BootBlocCubit extends Cubit<BootBlocState> {
  final Future<bool> Function() onStart;


  BootBlocCubit(this.onStart) : super(BootBlocState.INIT);

  @override
  // ignore: must_call_super
  void onError(Object error, StackTrace stackTrace) {
    print(error);
    print(stackTrace);
    emit(BootBlocState.ERROR);
  }

  Future<void> start() async {
    emit(BootBlocState.LOADING);
    bool result = true;
    try {
      result = await onStart();
      if (result)
        emit(BootBlocState.READY);
      else
        emit(BootBlocState.ERROR);
    } catch (e, stacktrace) {
      addError(e, stacktrace);
    }
  }
}
