import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

part 'nav_bar_state.dart';

@injectable
class NavBarCubit extends Cubit<NavBarState> {
  NavBarCubit(@factoryParam String? initPath) : super(NavBarState(initPath ?? "/"));

  void updatePath(String? newPath) {
    if (newPath != null) emit(NavBarState(newPath));
  }
}
