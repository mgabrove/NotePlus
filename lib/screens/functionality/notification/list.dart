import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class List extends StatefulWidget {
  @override
  _List createState() => _List();
}

class _List extends State<List> {

  pressedBack(){
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('List Notes'),
          backgroundColor: Colors.red,
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