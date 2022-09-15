import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class List extends StatefulWidget {
  @override
  _List createState() => _List();
}

class _List extends State<List> {

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
          child: Text("LIST"),
          onPressed: pressedBack,
        ),
      ),
    );
    /*return Container(
      color: Color.fromRGBO(236, 244, 248, 1),
      child: OutlinedButton(
        child: Text("LIST"),
        onPressed: pressedBack,
      ),
    );*/
  }
}