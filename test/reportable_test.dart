import 'package:covid19/src/models/country.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Test Mozambique cases', () {
    var moz = Country('Mozambique')
      ..confirmed = 10
      ..deaths = 0
      ..recovered = 5;

    expect('(66.7%)', moz.confirmedPerc);
    expect('(0.0%)', moz.deathsPerc);
    expect('(33.3%)', moz.recoveredPerc);
  });

  test('Test Mozambique flag', () async {
    expect('https://restcountries.eu/data/moz.svg',
        await Country('Mozambique').flag);
  });
}
