import 'package:date_format/date_format.dart';

parseDate({required String date}) {
  return formatDate(
      DateTime.parse(date.toString().trim()), [dd, '/', mm, '/', yyyy]);
}

parseDateWithTime({required String date}) {
  return formatDate(DateTime.parse(date.toString().trim()),
      [dd, '/', mm, '/', yyyy, ' ', hh, ':', mm, ':', ss]);
}
