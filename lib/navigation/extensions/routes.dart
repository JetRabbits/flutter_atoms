import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

import '../../navigation.dart';

extension JetCompassExt on String {
  CompassOperator compass() {
    return GetIt.I<CompassOperator>(param1: this);
  }

  String query(String name, String value){
    return "$this?$name=$value";
  }

  Future<T?> go<T>([Map<String, dynamic>? params]) async {
    return this.compass().switchOn().go<T>(params);
  }
}

extension BuildContextExt on BuildContext {
  Map<String, dynamic> get data {
    var namedRoute = ModalRoute.of(this)?.settings.name;
    return GetIt.I<CompassOperator>(param1: namedRoute).data;
  }
}
