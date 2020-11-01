import 'package:flutter/material.dart';
import 'LoadScreen.dart';
import 'HomeScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Préstamos Cayetano',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoadScreen(title: 'Sistema de préstamos'),
      routes: {
        HomeScreen.route : (context) => HomeScreen()
      }
    );
  }
}

