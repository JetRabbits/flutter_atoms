import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'nav_bar_state.dart';

class NavBarCubit extends Cubit<NavBarState> {
  NavBarCubit(String initPath) : super(NavBarState(initPath));
  void updatePath(String newPath){
    emit(NavBarState(newPath));
  }
}
