import 'package:covid19/src/client/api.dart';
import 'package:covid19/src/delegate/search.dart';
import 'package:covid19/src/models/global.dart';
import 'package:covid19/src/models/reportable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

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
                body: Column(
                  children: <Widget>[
                    _buildGlobalReport(context, global),
                    Expanded(
                      child: HomeScreen.buildListView(countries),
                    ),
                  ],
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
              return Center(
                  child: SpinKitDoubleBounce(
                      color: Theme.of(context).primaryColor));
          }));

  static Widget buildListView(List countries) => ListView.builder(
      itemCount: countries.length,
      itemBuilder: (context, index) => _buildTile(context, countries[index]));

  static Widget _buildTile(context, country) => ExpansionTile(
        title: Text(
          country.name,
          style: Theme.of(context).textTheme.subtitle,
        ),
        leading: CircleAvatar(child: Text(country.name[0])),
        children: <Widget>[
          _buildReport(context, country),
        ],
      );

  Widget _buildAppBar(context, countries) => AppBar(
        title: Text('Relátrio - COVID19'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () => showSearch(
                  context: context,
                  delegate: CountrySearch(results: countries)))
        ],
      );

  static Widget _buildGlobalReport(context, reportable) {
    return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 250.0,
            child: Column(children: <Widget>[
              Text(
                'Casos Globais',
                style: Theme.of(context).textTheme.display1,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                    'Última actualização: ${DateFormat('dd/mm/yyyy').format(reportable.date)}'),
              ),
              _buildReport(context, reportable),
            ]),
          ),
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
            Icon(Icons.report, size: 40.0, color: Colors.red),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Confirmados'),
            ),
            Text(
              format.format(reportable.confirmed),
              style: Theme.of(context).textTheme.subtitle,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(reportable.confirmedPerc),
            )
          ]),
          Column(children: <Widget>[
            Icon(Icons.clear, size: 40.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Mortes'),
            ),
            Text(
              format.format(reportable.deaths),
              style: Theme.of(context).textTheme.subtitle,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(reportable.deathsPerc),
            )
          ]),
          Column(children: <Widget>[
            Icon(Icons.healing, size: 40.0, color: Colors.green),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Recuperados'),
            ),
            Text(
              format.format(reportable.recovered),
              style: Theme.of(context).textTheme.subtitle,
            ),
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
