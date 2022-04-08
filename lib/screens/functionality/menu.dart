import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class Menu extends StatefulWidget {
  int menuChoice;
  Function(int) callback;

  Menu(this.menuChoice, this.callback);

  @override
  _Menu createState() => _Menu();
}

class _Menu extends State<Menu> {
  void pressedMap() {
    widget.callback(1);
  }

  void pressedList() {
    widget.callback(2);
  }

  void pressedCreate() {
    widget.callback(3);
  }

  void pressedSocial() {
    widget.callback(4);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(236, 244, 248, 1),
      child: Wrap(
        direction: Axis.vertical,
        children: <Widget>[
          OutlinedButton(
            child: Text("Map"),
            onPressed: pressedMap,
          ),
          OutlinedButton(
            child: Text("List"),
            onPressed: pressedList,
          ),
          OutlinedButton(
            child: Text("Create"),
            onPressed: pressedCreate,
          ),
          OutlinedButton(
            child: Text("Social"),
            onPressed: pressedSocial,
          ),
        ],
      )
    );
  }
}