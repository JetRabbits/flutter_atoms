import '../models/jet_compass.dart';

extension JetCompassExt on String {
  JetCompass compass() {
    return JetCompass(this);
  }

  Future<T?> go<T>() async {
    return this.compass().go<T>();
  }
}
