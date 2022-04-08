import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class List extends StatefulWidget {
  int menuChoice;
  Function(int) callback;

  List(this.menuChoice, this.callback);

  @override
  _List createState() => _List();
}

class _List extends State<List> {

  pressedBack(){
    widget.callback(0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(236, 244, 248, 1),
      child: OutlinedButton(
        child: Text("LIST"),
        onPressed: pressedBack,
      ),
    );
  }
}