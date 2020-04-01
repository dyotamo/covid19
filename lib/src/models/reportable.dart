abstract class Reportable {
  DateTime date;
  int confirmed;
  int deaths;
  int recovered;

  String get confirmedPerc =>
      '(${((confirmed / (confirmed + deaths + recovered)) * 100).toStringAsFixed(1)}%)';
  String get deathsPerc =>
      '(${((deaths / (confirmed + deaths + recovered)) * 100).toStringAsFixed(1)}%)';
  String get recoveredPerc =>
      '(${((recovered / (confirmed + deaths + recovered)) * 100).toStringAsFixed(1)}%)';

  Reportable({
    this.date,
    this.confirmed,
    this.deaths,
    this.recovered,
  });
}
