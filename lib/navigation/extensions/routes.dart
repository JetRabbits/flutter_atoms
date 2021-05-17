import 'package:get_it/get_it.dart';

import '../models/jet_compass.dart';

extension JetCompassExt on String {
  JetCompass compass() {
    return GetIt.I<JetCompass>(param1: this);
  }

  Future<T?> go<T>() async {
    return this.compass().go<T>();
  }
}
