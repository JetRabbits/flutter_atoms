
import 'package:logging/logging.dart';

void main(){
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
  var segments = Uri.parse("/").pathSegments;
  Logger('Test').fine(() => segments.first);
}