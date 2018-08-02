import 'package:flutter/material.dart';
import 'package:handwriting_borad/page/connection.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Handwriting Board',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new ConnectionPage(),
    );
  }
}
