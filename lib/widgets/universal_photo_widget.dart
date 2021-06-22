import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UniversalPhotoWidget extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;

  final Color? bodyColor;

  final double? borderRadius;

  final Color? borderColor;

  final double? borderWidth;

  UniversalPhotoWidget({
    Key? key,
    required this.url,
    this.width,
    this.height,
    this.bodyColor,
    this.borderRadius,
    this.borderColor,
    this.borderWidth,
  }) : super(key: key);

  ImageProvider selectProvider(String url) {
    if (url.startsWith("assets")) return AssetImage(url);
    if (url.startsWith("/") || url.startsWith("file:"))
      return FileImage(File(url));
    return CachedNetworkImageProvider(url);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: bodyColor ?? Colors.grey[300],
        image: DecorationImage(
          image: selectProvider(url),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 5.0)),
        border: Border.all(
          color: borderColor ?? Colors.grey,
          width: borderWidth ?? 1.0,
        ),
      ),
    );
  }
}
