import 'dart:convert';

import 'package:covid19/src/models/reportable.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Country extends Reportable {
  String name;

  Country(this.name);

  // res: [{"flag":"https://restcountries.eu/data/moz.svg"}]
  Future<String> get flag async {
    return jsonDecode((await http.get(
                'https://restcountries.eu/rest/v2/name/$name?fields=flag&fullText=true'))
            .body)
        .last['flag'];
  }

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
