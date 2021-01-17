import 'package:bloc/bloc.dart';

part 'nav_bar_state.dart';

class NavBarCubit extends Cubit<NavBarState> {
  NavBarCubit(String initPath) : super(NavBarState(initPath));
  void updatePath(String newPath){
    if (newPath != null) emit(NavBarState(newPath));
  }
}
