import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:developer' as developer;
import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:speech_to_text/speech_to_text.dart';

class Arguments {
  final String title_bar;
  final String text_message;

  Arguments(this.title_bar, this.text_message);
}

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
    createNote();
    Navigator.pop(context);
  }

  //
  SpeechToText speech = SpeechToText();
  String textString = "Press The Button";
  bool isListen = false;
  double confidence = 1.0;

  void listen() async {
    if (!isListen) {
      bool avail = await speech.initialize();
      if (avail) {
        String beforeCursorPositionAtTEC = controller.selection.textBefore(controller.text);
        String afterCursorPositionAtTEC = controller.selection.textAfter(controller.text);
        setState(() {
          isListen = true;
        });
        speech.listen(onResult: (value) {
          setState(() {
            textString = value.recognizedWords;
            controller.text = beforeCursorPositionAtTEC + textString + afterCursorPositionAtTEC;
          });
        });
      }
    } else {
      setState(() {
        isListen = false;
      });
      speech.stop();
    }
  }
  //

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

  void createNote() async{
    final docUser = FirebaseFirestore.instance.collection('notes').doc();
    await _getUserLocation();
    final json = {
      'id': docUser.id,
      'title': controllerTitle.value,
      'note': controller.value,
      'long': currentPostion.longitude,
      'lat': currentPostion.latitude,
      'groupId': _groupSelected != null ? _groupSelected : "personal",
    };
    await docUser.set(json);
  }

  String? _groupSelected;

  final controllerTitle = TextEditingController();
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {

    Map data = {};
    data = ModalRoute.of(context)!.settings.arguments as Map;
    _groupSelected = data != null ? data['group'] : null;

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
        body: ListView(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: "Title"),
              controller: controllerTitle,
              keyboardType: TextInputType.multiline,
              maxLines: 1,
            ),
            Stack(
              alignment: Alignment.bottomRight,
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(labelText: "Note"),
                  controller: controller,
                  keyboardType: TextInputType.multiline,
                  maxLines: 15,
                ),
                Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FloatingActionButton.extended(
                        backgroundColor: Color.fromRGBO(238, 51, 48, 1),
                        heroTag: "btn1",
                        onPressed: listen,
                        label: Text(""),
                        icon: Icon(isListen ? Icons.mic : Icons.mic_none),
                      ),
                    )
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('groups')
                          .where('users', arrayContains: FirebaseAuth.instance.currentUser?.uid)
                          .snapshots(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return Container(
                            child: DropdownButtonFormField<String>(
                              onChanged: (valueSelectedByUser) {
                                setState(() {
                                  _groupSelected = valueSelectedByUser;
                                });
                              },
                              hint: Text('Choose group'),
                              items: snapshot.data!.docs.map<DropdownMenuItem<String>>((DocumentSnapshot document) {
                                if(_groupSelected == null && document.get('name') == "personal") {
                                    _groupSelected = document.get('id');
                                }
                                return DropdownMenuItem<String>(
                                  value: document.get('id'),
                                  child: new Text(document.get('name')),
                                );
                              }).toList(),
                              value: _groupSelected,
                            ),
                          );
                        }
                      },
                    )
                ),
              ],
            ),
            Row(
                children: <Widget>[
                  Expanded(
                      child: OutlinedButton(
                        child: Text("Create"),
                        onPressed: pressedCreate,
                      ),
                  ),
                ]
            ),
          ],
        )
      ),
    );
  }
}