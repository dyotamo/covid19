import 'package:covid19/src/screens/home.dart';
import 'package:flutter/material.dart';

class CountrySearch extends SearchDelegate {
  List results;

  CountrySearch({this.results})
      : super(searchFieldLabel: 'Introduza o nome do país');

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = '',
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) => IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) => HomeScreen.buildListView(results
      .where(
          (result) => result.name.toLowerCase().contains(query.toLowerCase()))
      .toList());

  @override
  Widget buildSuggestions(BuildContext context) =>
      HomeScreen.buildListView(results
          .where((result) =>
              result.name.toLowerCase().contains(query.toLowerCase()))
          .toList());
}
