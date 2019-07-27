import 'package:flutter/material.dart';

class Multiplayer extends StatefulWidget {
  Multiplayer({Key key}) : super(key: key);

  _MultiplayerState createState() => _MultiplayerState();
}

class _MultiplayerState extends State<Multiplayer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Multiplayer'),),
      body: Center(child: Text('Multiplayer not implemented yet'),),
    );
  }
}