import 'package:covid19/src/models/report.dart';

class Country {
  String name;
  Report report;

  Country({this.name, this.report});

  factory Country.fromJson(name, List reports) {
    var country = Country(name: name);
    reports.forEach((report) => country.report = Report.fromJson(report));
    return country;
  }

  @override
  String toString() => '[country: $name, report: $report]';
}
