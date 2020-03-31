import 'package:covid19/src/client/api.dart';
import 'package:covid19/src/delegate/search.dart';
import 'package:covid19/src/models/global.dart';
import 'package:covid19/src/models/report.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();

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
          _buildReport(context, country.report),
        ],
      );

  static Widget _buildReport(context, Report report) {
    final format = NumberFormat();
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Card(
        elevation: 8.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
                  format.format(report.confirmed),
                  style: Theme.of(context).textTheme.subtitle,
                )
              ]),
              Column(children: <Widget>[
                Icon(Icons.clear, size: 40.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Mortes'),
                ),
                Text(
                  format.format(report.deaths),
                  style: Theme.of(context).textTheme.subtitle,
                )
              ]),
              Column(children: <Widget>[
                Icon(Icons.healing, size: 40.0, color: Colors.green),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Recuperados'),
                ),
                Text(
                  format.format(report.recovered),
                  style: Theme.of(context).textTheme.subtitle,
                )
              ])
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
          body: RefreshIndicator(
        child: FutureBuilder<Map<String, dynamic>>(
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
                return Center(child: CircularProgressIndicator());
            }),
        onRefresh: () => _refresh(),
      ));

  Widget _buildAppBar(context, countries) => AppBar(
        title: Text('Mapa do COVID-19'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () => showSearch(
                  context: context,
                  delegate: CountrySearch(results: countries)))
        ],
      );

  Widget _buildGlobalReport(context, Global global) {
    final format = NumberFormat();

    return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 175.0,
            child: Column(children: <Widget>[
              Text(
                'Casos Globais',
                style: Theme.of(context).textTheme.display1,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                    'Última actualização: ${DateFormat('dd/mm/yyyy').format(global.date)}'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(children: <Widget>[
                    Icon(Icons.report, size: 40.0, color: Colors.red),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Confirmados'),
                    ),
                    Text(
                      format.format(global.confirmed),
                      style: Theme.of(context).textTheme.subtitle,
                    )
                  ]),
                  Column(children: <Widget>[
                    Icon(Icons.clear, size: 40.0),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Mortes'),
                    ),
                    Text(
                      format.format(global.deaths),
                      style: Theme.of(context).textTheme.subtitle,
                    )
                  ]),
                  Column(children: <Widget>[
                    Icon(Icons.healing, size: 40.0, color: Colors.green),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Recuperados'),
                    ),
                    Text(
                      format.format(global.recovered),
                      style: Theme.of(context).textTheme.subtitle,
                    )
                  ])
                ],
              ),
            ]),
          ),
        ));
  }

  Future<void> _refresh() {
    return Future.value();
  }
}
