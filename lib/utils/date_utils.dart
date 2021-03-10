import 'package:flutter_atoms/generated/l10n.dart';
import 'package:intl/intl.dart';

class DateTimePatterns {
  static const PATTERN_DATE_WITH_FULL_TIME = 'yyyy-MM-dd HH:mm:ss';
  static const PATTERN_DATE_WITH_SHORT_TIME = 'yyyy-MM-dd HH:mm';
  static const SERVER_PATTERN_DATE_WITH_TIME = 'dd-MM-yyyy HH:mm:ss';
  static const PATTERN_DATE_WITHOUT_TIME = 'yyyy-MM-dd';
  static const PATTERN_TEXT_DATE_WITHOUT_TIME = 'dd MMMM yyyy';
  static DateFormat createDateFormat(String pattern, [String localeCode]) {
    return DateFormat(pattern, localeCode ?? Intl.getCurrentLocale());
  }
}

class JsonDateTimeText {
  static DateTime dateTimeFromString(String value, [String pattern]) {
    if (value == null) return null;


    DateTime _ = DateTime.tryParse(value)?.toLocal();
    if (_ == null) {
      //todo: split
      var split = value.split(RegExp(r'[Z+-]'));
      print(split);
      try {
        _ = DateFormat(pattern ?? DateTimePatterns.SERVER_PATTERN_DATE_WITH_TIME)
            .parse(value)
            ?.toLocal();
      } catch (e) {
        print(e);
      }
    }

    return _;
  }

  static String toStringWithFullTime(DateTime dateTime) =>
      dateTime == null
      ? null
          : DateFormat(DateTimePatterns.PATTERN_DATE_WITH_FULL_TIME).format(dateTime);

  static String toStringWithShortTime(DateTime dateTime) =>
      dateTime == null
          ? null
          : DateFormat(DateTimePatterns.PATTERN_DATE_WITH_SHORT_TIME).format(dateTime);

  static String toStringWithTimeZone(DateTime dateTime, {String format='yyyy-MM-ddTHH:mm:ss', Duration timeZoneOffset}) {
    if (dateTime == null) return null;

    Duration _timeZone;

    if (timeZoneOffset != null) {
      _timeZone = timeZoneOffset;
    } else {
      _timeZone = dateTime.timeZoneOffset;
    }

    return DateFormat(format).format(dateTime) +
        (_timeZone.isNegative ? "" : "+") +
        NumberFormat('00').format(_timeZone.inHours) +
        NumberFormat('00').format((_timeZone.inMinutes % 60).ceil());
  }

  static String toStringWithoutTime(DateTime dateTime) => dateTime == null
      ? null
      : DateFormat(DateTimePatterns.PATTERN_DATE_WITHOUT_TIME).format(dateTime);
}

/// Formats date time value relative current time to more
/// human presentable string like today, tomorrow, yesterday
///
String humanReadableDateTime(DateTime value) {
  if (value != null) {
    var _dt1 = DateTime(value.year, value.month, value.day);
    var _dt2 = DateTime.now();
    _dt2 = DateTime(_dt2.year, _dt2.month, _dt2.day);
    var dif = _dt1.difference(_dt2).inDays;
    if (dif == 0) {
      return AtomsStrings.current.today;
    } else if (dif == 1) {
      return AtomsStrings.current.tomorrow;
    } else if (dif == -1) {
      return AtomsStrings.current.yesterday;
    } else {
      if (_dt1.year != _dt2.year) {
        return DateTimePatterns.createDateFormat('d MMMM yyyy').format(value);
      } else {
        return DateTimePatterns.createDateFormat('d MMMM').format(value);
      }
    }
  }
  return "";
}


String humanReadableDatePeriod(DateTime startDate, DateTime endDate) {
  if (startDate.year == endDate.year && startDate.month == endDate.month) {
    int year = startDate.year;
    int month = startDate.month;

    var firstDayOfMonth = getFirstDayOfMonth(year, month);
    var lastDayOfMonth = getLastDayOfMonth(year, month);

    if (
      startDate.day == firstDayOfMonth.day &&
      endDate.day == lastDayOfMonth.day
    )
    {
      var dateFormat =
        DateFormat.MMMM(Intl.getCurrentLocale());

      if (DateTime.now().year != year) dateFormat.add_y();
      var startDateString = dateFormat.format(startDate);
      return startDateString.substring(0, 1).toUpperCase() + startDateString.substring(1);
    }
  }

  String dateRange =
      JsonDateTimeText.toStringWithoutTime(startDate) +
          " ... " +
          JsonDateTimeText.toStringWithoutTime(endDate);

  return dateRange;
}


DateTime getFirstDayOfMonth(int year, int month) {
  return DateTime(year, month, 1);
}


DateTime getLastDayOfMonth(int year, int month) {
  return month == 12 ? DateTime(year + 1, 1, 0) : DateTime(year, month + 1, 0);
}


String durationString(Duration duration) {
  var _ = duration.toString();
  return _.substring(0, _.length - 10);
}

Duration convertToTimeZoneOffset(String tsOffsetString) {
  Duration timeZoneOffset;

  try {
    final match =
    RegExp(r"^([+-])([0-9]{2})([0-9]{2})$").firstMatch(tsOffsetString);
    final bool isPositive = match.group(1) == "+";
    final int h = int.parse(match.group(2));
    final int m = int.parse(match.group(3));
    timeZoneOffset = isPositive
        ? Duration(hours: h, minutes: m)
        : Duration(hours: -h, minutes: -m);
  } catch (e) {
    timeZoneOffset = null;
  }

  return timeZoneOffset;
}
