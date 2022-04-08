import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class Create extends StatefulWidget {
  @override
  _Create createState() => _Create();
}

class _Create extends State<Create> {

  pressedBack(){
    Navigator.pop(context);
  }
  pressedCreate(){
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Create Note'),
          backgroundColor: Colors.red,
        ),
        body: ListView(
          children: <Widget>[
            TextField(
              keyboardType: TextInputType.multiline,
              maxLines: 15,
            ),
            Row(
                children: <Widget>[
                  Expanded(
                      child: OutlinedButton(
                        child: Text("Create"),
                        onPressed: pressedCreate,
                      ),
                  ),
                  Expanded(
                      child: OutlinedButton(
                        child: Text("Return"),
                        onPressed: pressedBack,
                      ),
                  )
                ]
            ),
          ],
        )
      ),
    );
    /*return Container(
      color: Color.fromRGBO(236, 244, 248, 1),
      child: OutlinedButton(
        child: Text("CREATE"),
        onPressed: pressedBack,
      ),
    );*/
  }
}