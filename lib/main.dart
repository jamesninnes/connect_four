import 'package:connect_four/pages/Home/Home.dart';
import 'package:connect_four/pages/Local/Local.dart';
import 'package:connect_four/pages/Multiplayer/Multiplayer.dart';
import 'package:connect_four/pages/vsAI/vsAI.dart';
import 'package:flutter/material.dart';

void main() => runApp(ConnectFour());

class ConnectFour extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Connect Four Game',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: Home(),
      routes: <String, WidgetBuilder> {
          '/Local': (BuildContext context) => Local(),
          '/Multiplayer': (BuildContext context) => Multiplayer(),
          '/vsAI': (BuildContext context) => vsAI(),
      },
    );
  }
}
