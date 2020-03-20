import 'package:flutter/material.dart';
import 'package:httptest/http_test_body.dart';

void main() {
  runApp(TheApp());
}

class TheApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Http Test',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: HomePage(title: 'Http Test'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: HttpTestBody() // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
