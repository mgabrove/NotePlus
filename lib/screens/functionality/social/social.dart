import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class Social extends StatefulWidget {
  @override
  _Social createState() => _Social();
}

class _Social extends State<Social> {

  pressedBack(){
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Social'),
          backgroundColor: Colors.red,
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