import 'package:flutter/cupertino.dart';
import 'package:flutter_atoms/flutter_atoms.dart';
import 'package:flutter_atoms/utils/date_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  setUp(() async {
    await AtomsStrings.load(Locale('ru'));
    await initializeDateFormatting();
  });

  group("Date Utils", () {
    test('Human readable date string', () async {
      var result = humanReadableDateTime(DateTime.now());
      expect(result, "Сегодня");
      result =
          humanReadableDateTime(DateTime.now().subtract(Duration(days: 1)));
      expect(result, "Вчера");
      result = humanReadableDateTime(DateTime.now().add(Duration(days: 1)));
      expect(result, "Завтра");
    });
    test('Json DateTime parse', () async {
      var result = JsonDateTimeText.dateTimeFromString("01-01-2021 14:00:00");
      print(result);
      expect(result, DateTime(2021, 1, 1, 14, 0));
    });
    test('DateTimeFormat', () async {
      var createDateFormat = DateTimePatterns.createDateFormat(DateTimePatterns.PATTERN_DATE_WITH_FULL_TIME);
      var dt = DateTime(2021, 1, 1, 14, 0);
      var result = createDateFormat.format(dt);
      print(result);
      print(dt);
      expect(result, contains('2021-'));
    });
    test('DateTimeFormat is ignore timezone', () async {
      //yyyy-MM-dd HH:mm:ss
      var createDateFormat = DateTimePatterns.createDateFormat(DateTimePatterns.PATTERN_DATE_WITH_FULL_TIME);
      var parse = createDateFormat.parse("2021-01-03 10:00:00+01000000");
      print(parse);
    });
  });
}
