import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class Map extends StatefulWidget {
  int menuChoice;
  Function(int) callback;

  Map(this.menuChoice, this.callback);

  @override
  _Map createState() => _Map();
}

class _Map extends State<Map> {

  pressedBack(){
    widget.callback(0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(236, 244, 248, 1),
      child: OutlinedButton(
        child: Text("MAP"),
        onPressed: pressedBack,
      ),
    );
  }
}