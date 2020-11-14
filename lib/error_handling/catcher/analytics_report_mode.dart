import 'package:catcher/catcher.dart';
import 'package:catcher/model/platform_type.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_atoms/integrations/analytics.dart';

///
/// Catcher report mode powered by Google Analytics/Crashlytics
///
class AnalyticsCatcherReportMode extends ReportMode {

  @override
  void requestAction(Report report, BuildContext context) {
    Analytics.of(context)
        .logError(report.error, report.stackTrace, report.customParameters);
  }

  @override
  bool isContextRequired() {
    return true;
  }

  @override
  List<PlatformType> getSupportedPlatforms() =>
      [PlatformType.Android, PlatformType.iOS, PlatformType.Web, PlatformType.Unknown];
}
