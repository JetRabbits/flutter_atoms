import 'package:flutter/material.dart';

class ButtonConfig {
  const ButtonConfig({
    required this.icon,
    this.title,
    this.label,
    Widget? activeIcon,
    this.backgroundColor,
    this.tooltip,
  })  : activeIcon = activeIcon ?? icon,
        assert(label == null || title == null);
  final Widget icon;
  final Widget activeIcon;
  final Widget? title;
  final String? label;
  final Color? backgroundColor;
  final String? tooltip;
}
