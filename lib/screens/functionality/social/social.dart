import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class Social extends StatefulWidget {
  int menuChoice;
  Function(int) callback;

  Social(this.menuChoice, this.callback);

  @override
  _Social createState() => _Social();
}

class _Social extends State<Social> {

  pressedBack(){
    widget.callback(0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color.fromRGBO(236, 244, 248, 1),
        child: OutlinedButton(
          child: Text("SOCIAL"),
          onPressed: pressedBack,
        ),
    );
  }
}