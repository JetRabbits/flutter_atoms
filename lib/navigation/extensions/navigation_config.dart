import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_atoms/flutter_atoms.dart';

extension RouteToNavigationButton on String {
  MapEntry<String, NavigationRailDestinationBuilder> railButton({required Widget icon, Widget? label}) {
    return MapEntry(this, (context) => NavigationRailDestination(icon: icon, label: label));
  }
}