import 'package:get_it/get_it.dart';

import '../models/jet_compass.dart';

extension JetCompassExt on String {
  JetCompass compass() {
    return GetIt.I<JetCompass>(param1: this);
  }

  Future<T?> go<T>({Map<String, String>? params, bool replace = false}) async {
      return replace ? this.compass().replace().go<T>(): this.compass().go<T>(params);
  }
}
