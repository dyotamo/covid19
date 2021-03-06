import 'package:covid19/src/client/api.dart';
import 'package:covid19/src/delegate/search.dart';
import 'package:covid19/src/models/country.dart';
import 'package:covid19/src/models/global.dart';
import 'package:covid19/src/models/reportable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';

class HomeScreen extends StatelessWidget {
  Widget build(BuildContext context) => Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Global global = snapshot.data['global'];
              List countries = snapshot.data['countries'];

              return Scaffold(
                appBar: _buildAppBar(context, countries),
                body: OrientationBuilder(
                  builder: (context, orientation) =>
                      (orientation == Orientation.landscape)
                          ? Row(
                              children: <Widget>[
                                _buildGlobalReport(context, global),
                                Expanded(
                                    child: HomeScreen.buildListView(countries)),
                              ],
                            )
                          : Column(
                              children: <Widget>[
                                _buildGlobalReport(context, global),
                                Expanded(
                                  child: HomeScreen.buildListView(countries),
                                ),
                              ],
                            ),
                ),
              );
            } else if (snapshot.hasError)
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: Text(
                  snapshot.error.toString(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.subtitle,
                )),
              );
            else
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                      child: SpinKitDoubleBounce(
                          color: Theme.of(context).primaryColor)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Carregando dados...',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline,
                    ),
                  ),
                ],
              );
          }));

  static Widget buildListView(List countries) => ListView.builder(
      itemCount: countries.length,
      itemBuilder: (context, index) => _buildTile(context, countries[index]));

  static Widget _buildTile(context, Country country) => Padding(
        padding: const EdgeInsets.all(5.0),
        child: Card(
          elevation: 2.5,
          child: ExpansionTile(
            title:
                Text(country.name, style: Theme.of(context).textTheme.subtitle),
            leading: FutureBuilder<String>(
                future: country.flag,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SvgPicture.network(
                      snapshot.data,
                      key: Key(snapshot.data),
                      width: 50.0,
                      fit: BoxFit.cover,
                      placeholderBuilder: (context) =>
                          _buildImagePlaceholder(country),
                    );
                  }

                  return _buildImagePlaceholder(country);
                }),
            children: <Widget>[
              _buildReport(context, country),
            ],
          ),
        ),
      );

  static Container _buildImagePlaceholder(Country country) {
    return Container(
        width: 50.0,
        child: CircleAvatar(child: Text(country.name.substring(0, 2))));
  }

  Widget _buildAppBar(context, countries) => AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Casos em ${DateFormat('dd/mm/yyyy').format(countries.first.date)}',
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.black,
              ),
              onPressed: () => showSearch(
                  context: context,
                  delegate: CountrySearch(results: countries)))
        ],
      );

  static Widget _buildGlobalReport(context, reportable) {
    var map = <String, double>{}
      ..['Confirmados'] = double.parse(reportable.confirmed.toString())
      ..['Mortes'] = double.parse(reportable.deaths.toString())
      ..['Recuperados'] = double.parse(reportable.recovered.toString());

    return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          height: 215.0,
          child: Column(children: <Widget>[
            Container(
              height: 120.0,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: PieChart(
                  dataMap: map,
                  chartType: ChartType.ring,
                  showLegends: false,
                  colorList: const <Color>[
                    Colors.red,
                    Colors.black,
                    Colors.green
                  ],
                  decimalPlaces: 1,
                ),
              ),
            ),
            _buildReport(context, reportable)
          ]),
        ));
  }

  static Widget _buildReport(context, Reportable reportable) {
    final format = NumberFormat();

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(children: <Widget>[
            Icon(
              FontAwesomeIcons.hospitalUser,
              size: 20.0,
              color: Colors.red,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Confirmados'),
            ),
            Text(
              format.format(reportable.confirmed),
              style: Theme.of(context).textTheme.subtitle,
            ),
            // Not good design, but works perfectly
            if (reportable is Country)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(reportable.confirmedPerc),
              )
          ]),
          Column(children: <Widget>[
            Icon(
              FontAwesomeIcons.dizzy,
              size: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Mortes'),
            ),
            Text(
              format.format(reportable.deaths),
              style: Theme.of(context).textTheme.subtitle,
            ),
            if (reportable is Country)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(reportable.deathsPerc),
              )
          ]),
          Column(children: <Widget>[
            Icon(
              Icons.healing,
              size: 20.0,
              color: Colors.green,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Curados'),
            ),
            Text(
              format.format(reportable.recovered),
              style: Theme.of(context).textTheme.subtitle,
            ),
            if (reportable is Country)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(reportable.recoveredPerc),
              )
          ])
        ],
      ),
    );
  }
}
