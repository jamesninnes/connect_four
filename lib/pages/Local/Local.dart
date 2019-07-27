import 'package:connect_four/widgets/GameBoard.dart';
import 'package:flutter/material.dart';

class Local extends StatefulWidget {
  Local({Key key, this.columns, this.rows}) : super(key: key);

  final int columns;
  final int rows;

  _LocalState createState() => _LocalState();
}

class _LocalState extends State<Local> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Local')),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: GameBoard(rows: 6, columns: 7),
        )
      ),
    );
  }
}