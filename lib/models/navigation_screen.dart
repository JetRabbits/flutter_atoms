import 'package:flutter/widgets.dart';

import 'screen_group.dart';

class NavigationScreen {
  final String path;
  final WidgetBuilder builder;
  final ScreenGroup group;
  final int index;

  NavigationScreen({@required  this.path, @required this.builder, @required this.group, @required this.index});
}
