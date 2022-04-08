import 'package:flutter/material.dart';

import 'package:note_complete/screens/functionality/notification/map.dart';
import 'package:note_complete/screens/functionality/notification/list.dart';
import 'package:note_complete/screens/functionality/notification/create.dart';
import 'package:note_complete/screens/functionality/social/social.dart';
import 'package:note_complete/screens/functionality/menu.dart';

class Home extends StatefulWidget {
  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {

  Color customRed = Color.fromRGBO(238, 51, 48, 1);

  int menuChoice = 0;

  callback(newAbc) {
    setState(() {
      menuChoice = newAbc;
    });
  }

  Widget getWidget() {
    if(menuChoice == 1) {
      return Map(menuChoice, callback);
    }
    else if(menuChoice == 2) {
      return List(menuChoice, callback);
    }
    else if(menuChoice == 3) {
      return Create(menuChoice, callback);
    }
    else if(menuChoice == 4) {
      return Social(menuChoice, callback);
    }
    else {
      return Menu(menuChoice, callback);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Note Complete"),
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
      body: getWidget(),
    );
  }
}