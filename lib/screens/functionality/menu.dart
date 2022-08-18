import 'package:flutter/material.dart';
import 'package:note_complete/screens/functionality/notification/map.dart';
import 'package:note_complete/screens/functionality/notification/list.dart';
import 'package:note_complete/screens/functionality/notification/create.dart';
import 'package:note_complete/screens/functionality/social/social.dart';

class Menu extends StatefulWidget {
  @override
  _Menu createState() => _Menu();
}

class _Menu extends State<Menu> {
  void pressedMap() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Map()),
    );
  }

  void pressedList() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => List()),
    );
  }

  void pressedCreate() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Create()),
    );
  }

  void pressedSocial() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Social()),
    );
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