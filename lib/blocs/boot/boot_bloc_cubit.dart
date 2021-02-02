import 'package:bloc/bloc.dart';

part 'boot_bloc_state.dart';

class BootBlocCubit extends Cubit<BootBlocState> {
  final Future<bool> Function() onStart;


  BootBlocCubit(this.onStart) : super(BootBlocState.INIT);

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    print(stackTrace);
    emit(BootBlocState.ERROR);
  }

  Future<void> start() async {
    emit(BootBlocState.LOADING);
    bool result = true;
    try {
      if (onStart != null) result = await onStart();
    } catch (e, stacktrace) {
      addError(e, stacktrace);
    }
    // await Future.delayed(Duration(seconds: 2));

    if (result)
      emit(BootBlocState.READY);
    else
      emit(BootBlocState.ERROR);

  }
}
