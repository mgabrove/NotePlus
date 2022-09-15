import 'package:flutter/material.dart';
import 'package:note_complete/screens/header.dart';

class Social extends StatefulWidget {
  @override
  _Social createState() => _Social();
}

class _Social extends State<Social> {

  Color customRed = Color.fromRGBO(238, 51, 48, 1);

  pressedBack(){
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Note Complete"),
          backgroundColor: Color.fromRGBO(238, 51, 48, 1),
          elevation: 0.0,
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: pressedBack,
                  child: Icon(
                    Icons.arrow_back,
                  ),
                )
            ),
          ],
        ),
        body: OutlinedButton(
          child: Text("SOCIAL"),
          onPressed: pressedBack,
        ),
      ),
    );
  }
}