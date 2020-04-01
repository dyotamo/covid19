import 'package:covid19/src/models/reportable.dart';
import 'package:intl/intl.dart';

class Country extends Reportable {
  String name;

  Country(this.name);

  factory Country.fromJson(name, reports) {
    var country = Country(name);
    reports.forEach((report) {
      country.date = DateFormat('yyyy-mm-dd').parse(report['date']);
      country.confirmed = report['confirmed'];
      country.deaths = report['deaths'];
      country.recovered = report['recovered'];
    });
    return country;
  }

  @override
  String toString() => name;
}
