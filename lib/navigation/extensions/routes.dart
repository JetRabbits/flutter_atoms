import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

import '../../navigation.dart';

extension JetCompassExt on String {
  CompassOperator compass() {
    return GetIt.I<CompassOperator>(param1: this);
  }

  Future<T?> go<T>([Map<String, dynamic>? params]) async {
    return this.compass().switchOn().go<T>(params);
  }
}

extension BuildContextExt on BuildContext {
  Map<String, dynamic> get data {
    var namedRoute = ModalRoute.of(this)?.settings.name;
    print("####${ModalRoute.of(this)}");
    return GetIt.I<CompassOperator>(param1: namedRoute).data;
  }
}
