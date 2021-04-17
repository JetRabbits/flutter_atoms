import 'package:flutter/material.dart';

class CircleCheckBox extends StatelessWidget {
  final Color? selectedColor;
  final Color? color;
  final bool isLoading;
  final bool isEnabled;
  final bool isChecked;
  final Function(bool value)? onTap;

  final EdgeInsetsGeometry padding;

  const CircleCheckBox({
    Key? key,
    this.selectedColor,
    this.color,
    this.padding = const EdgeInsets.all(4.0),
    this.isLoading = false,
    this.isChecked = false,
    this.isEnabled = true,
    this.onTap
  })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => isEnabled && !isLoading ? onTap!(!isChecked) : null,
      child: Container(
        decoration: BoxDecoration(color: Colors.transparent),
        child: Padding(
          padding: padding,
          child: isLoading
                ? _buildLoadingCheckBox(context)
                : _buildLoadedCheckBox(context),
        ),
      ),
    );
  }

  Widget _buildLoadingCheckBox(BuildContext context) {
    return Container(
        width: _INTERNAL_RADIUS * 2,
        height: _INTERNAL_RADIUS * 2,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(color ?? Theme.of(context).accentColor),
          strokeWidth: _EXTERNAL_RADIUS - _INTERNAL_RADIUS
        )
    );
  }

  Widget _buildLoadedCheckBox(BuildContext context) {
    Color externalBgColor, internalBgColor;

    if (isEnabled) {
      externalBgColor = isChecked
          ? selectedColor ?? Theme.of(context).accentColor
          : color ?? Theme.of(context).accentColor;
      internalBgColor = isChecked
          ? selectedColor ?? Theme.of(context).accentColor
          : Theme.of(context).cardColor;
    }
    else {
      externalBgColor = isChecked
          ? selectedColor ?? Theme.of(context).disabledColor
          : color ?? Theme.of(context).disabledColor;
      internalBgColor = isChecked
          ? selectedColor ?? Colors.black12
          : Theme.of(context).cardColor;
    }

    return CircleAvatar(
      backgroundColor: externalBgColor,
      radius: _EXTERNAL_RADIUS,
      child: CircleAvatar(
        backgroundColor: internalBgColor,
        radius: _INTERNAL_RADIUS,
        child: isChecked ? Icon(Icons.check, size: 20.0) : Container(width: 0),
      )
    );
  }

  static const _EXTERNAL_RADIUS = 14.0;
  static const _INTERNAL_RADIUS = 12.0;
}
