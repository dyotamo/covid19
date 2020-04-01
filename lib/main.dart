import 'package:covid19/src/screens/home.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Covid19 Monitor',
      home: HomeScreen(),
      theme: ThemeData(primarySwatch: Colors.teal),
    );
  }
}
