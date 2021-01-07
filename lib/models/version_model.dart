import 'package:flutter/services.dart';
import 'package:get_version/get_version.dart';

class VersionModel {
  String projectName = "-";
  String platformVersion = "-";
  String projectVersion = "-";
  String projectCode = "-";
  String projectAppID = "-";

  load() async {
    try {
      platformVersion = await GetVersion.platformVersion;
    } on PlatformException {}

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      projectVersion = await GetVersion.projectVersion;
    } on PlatformException {}

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      projectCode = await GetVersion.projectCode;
    } on PlatformException {}

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      projectAppID = await GetVersion.appID;
    } on PlatformException {}

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      projectName = await GetVersion.appName;
    } on PlatformException {}
  }

  @override
  String toString() {
    return projectVersion != "-"
        ? 'v$projectVersion (build: $projectCode)'
        : "-";
  }
}
