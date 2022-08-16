import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'package:geolocator/geolocator.dart';

import 'dart:developer' as developer;

import 'package:google_maps_flutter/google_maps_flutter.dart';

class Create extends StatefulWidget {
  @override
  _Create createState() => _Create();
}

class _Create extends State<Create> {

  Color customRed = Color.fromRGBO(238, 51, 48, 1);

  pressedBack(){
    Navigator.pop(context);
  }
  pressedCreate(){
    final note = controller.text;
    createNote(note: note);
    Navigator.pop(context);
  }

  late LatLng currentPostion;

  LatLng currentPosition() {
    return currentPostion;
  }

  _getUserLocation() async {
    var position = await Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      currentPostion = LatLng(position.latitude, position.longitude);
    });
  }

  void createNote({required String note}) async{
    final docUser = FirebaseFirestore.instance.collection('notes').doc();

    await _getUserLocation();

    final json = {
      'id': docUser.id,
      'note': note,
      'long': currentPostion.longitude,
      'lat': currentPostion.latitude,
      'group_id': '23',

    };

    await docUser.set(json);
  }

  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Note Complete - Create"),
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
        body: ListView(
          children: <Widget>[
            TextField(
              controller: controller,
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