import 'dart:convert';

import 'package:covid19/src/models/country.dart';
import 'package:covid19/src/models/global.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> fetchData() async => compute(_parseJson,
    (await http.get('https://pomber.github.io/covid19/timeseries.json')).body);

Map<String, dynamic> _parseJson(body) {
  var json = jsonDecode(body);
  var countries = [];

  int totalConfirmed = 0;
  int totalDeaths = 0;
  int totalRecovered = 0;

  json.forEach((name, reports) {
    var country = Country.fromJson(name, reports);

    totalConfirmed += country.report.confirmed;
    totalDeaths += country.report.deaths;
    totalRecovered += country.report.recovered;

    countries.add(country);
  });

  countries.sort(
    (a, b) => b.report.confirmed.compareTo(a.report.confirmed),
  );

  var map = Map<String, dynamic>();
  map['countries'] = countries;
  map['global'] = Global(
      confirmed: totalConfirmed,
      deaths: totalDeaths,
      recovered: totalRecovered);

  return map;
}
