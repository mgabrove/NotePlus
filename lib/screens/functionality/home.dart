import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'package:note_complete/screens/functionality/notification/map.dart';
import 'package:note_complete/screens/functionality/notification/list.dart';
import 'package:note_complete/screens/functionality/notification/create.dart';
import 'package:note_complete/screens/functionality/social/social.dart';

class Home extends StatefulWidget {
  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {

  Color customRed = Color.fromRGBO(238, 51, 48, 1);

  int menuChoice = 0;

  void pressedMap() {
    Navigator.push(
      context,
      PageRouteBuilder(pageBuilder: (_, __, ___) => Map()),
      //MaterialPageRoute(builder: (context) => Map()),
    );
  }

  void pressedList() {
    Navigator.push(
      context,
      PageRouteBuilder(pageBuilder: (_, __, ___) => List()),
      //MaterialPageRoute(builder: (context) => List()),
    );
  }

  void pressedCreate() {
    Navigator.push(
      context,
      PageRouteBuilder(pageBuilder: (_, __, ___) => Create()),
      //MaterialPageRoute(builder: (context) => Create()),
    );
  }

  void pressedSocial() {
    Navigator.push(
      context,
      PageRouteBuilder(pageBuilder: (_, __, ___) => Social()),
      //MaterialPageRoute(builder: (context) => Social()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Note Complete - Menu"),
        backgroundColor: customRed,
        elevation: 0.0,
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                child: Icon(
                  Icons.favorite,
                ),
              )
          ),
        ],
      ),
      body: Container(
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
      ),
    );
  }
}