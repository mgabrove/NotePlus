import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

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
          title: Text("Note Complete - Social"),
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
        body: OutlinedButton(
          child: Text("SOCIAL"),
          onPressed: pressedBack,
        ),
      ),
    );
    /*return Container(
        color: Color.fromRGBO(236, 244, 248, 1),
        child: OutlinedButton(
          child: Text("SOCIAL"),
          onPressed: pressedBack,
        ),
    );*/
  }
}