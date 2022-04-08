import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class Create extends StatefulWidget {
  int menuChoice;
  Function(int) callback;

  Create(this.menuChoice, this.callback);

  @override
  _Create createState() => _Create();
}

class _Create extends State<Create> {

  pressedBack(){
    widget.callback(0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(236, 244, 248, 1),
      child: OutlinedButton(
        child: Text("CREATE"),
        onPressed: pressedBack,
      ),
    );
  }
}