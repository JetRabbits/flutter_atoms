import 'package:get_it/get_it.dart';

import '../models/compass.dart';

extension JetCompassExt on String {
  Compass compass() {
    return GetIt.I<Compass>(param1: this);
  }

  Future<T?> go<T>({Map<String, String>? params, bool replace = false}) async {
      return replace ? this.compass().replace().go<T>(): this.compass().go<T>(params);
  }
}
