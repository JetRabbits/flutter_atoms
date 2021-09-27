class NoRouteFoundException implements Exception {
  final String path;
  NoRouteFoundException(this.path);

  @override
  String toString() {
    return 'NoRouteFoundException{path: $path} please check your Navigation Model';
  }
}