import 'package:example/example.dart';
import 'package:example_flutter/example.dart';
import 'package:flutter/material.dart';
import 'package:flutter_built_bloc/flutter_built_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'built_bloc Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text("built_bloc")),
        body: Example(),
      ),
    );
  }
}
