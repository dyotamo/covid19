import 'package:intl/intl.dart';

class Report {
  DateTime date;
  int confirmed;
  int deaths;
  int recovered;

  Report.fromJson(Map json) {
    date = DateFormat('yyyy-mm-dd').parse(json['date']);
    confirmed = json['confirmed'];
    deaths = json['deaths'];
    recovered = json['recovered'];
  }

  @override
  String toString() =>
      '[date: $date, confirmed: $confirmed, deaths: $deaths, recovered: $recovered]';
}
