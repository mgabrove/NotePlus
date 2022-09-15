import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_complete/screens/customdialog.dart';

class Home extends StatefulWidget {
  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {

  Color customRed = Color.fromRGBO(238, 51, 48, 1);

  int menuChoice = 0;

  void pressedMap() {
    Navigator.pushNamed(context, "/map");
  }
  void pressedList() {
    Navigator.pushNamed(context, "/list");
  }
  void pressedCreate() {
    Navigator.pushNamed(context, "/create");
  }
  void pressedSocial() {
    Navigator.pushNamed(context, "/social");
  }

  void logout() {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, "/login");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Note Complete"),
          backgroundColor: Color.fromRGBO(238, 51, 48, 1),
          elevation: 0.0,
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () async {
                    var pressedButton = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return CustomDialog("Are you sure\nyou want to log out?", "Yes", "No");
                        }
                    );
                    if (pressedButton == true) logout();
                  },
                  child: Icon(
                    Icons.logout,
                  ),
                )
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 40),
              RaisedButton(
                child: Text("Map"),
                onPressed: pressedMap,
              ),
              RaisedButton(
                child: Text("List"),
                onPressed: pressedList,
              ),
              RaisedButton(
                child: Text("Create"),
                onPressed: pressedCreate,
              ),
              RaisedButton(
                child: Text("Social"),
                onPressed: pressedSocial,
              ),
            ],
          ),
        )
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Note Complete"),
        backgroundColor: Color.fromRGBO(238, 51, 48, 1),
        elevation: 0.0,
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () async {
                  var pressedButton = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return CustomDialog("Are you sure you want to log out?", "Yes", "No");
                      }
                  );
                  if (pressedButton == true) logout();
                },
                child: Icon(
                  Icons.logout,
                ),
              )
          ),
        ],
      ),
      body: Container(
          width: double.infinity,
          height: 500,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
            ],
          )
      ),
    );
  }
}