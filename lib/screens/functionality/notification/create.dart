import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:developer' as developer;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'group.dart';

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
    //final docGroup = selectGroup();

    await _getUserLocation();

    final json = {
      'id': docUser.id,
      'note': note,
      'long': currentPostion.longitude,
      'lat': currentPostion.latitude,
      //'group_id': docGroup,
    };

    await docUser.set(json);
  }

  String? _groupSelected;

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
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('groups')
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
                          //DocumentSnapshot ds = snapshot.data.docs;
                          final data = snapshot.data!;
                          var _value;
                          return DropdownButtonFormField(
                              style: TextStyle(color: Colors.white70),
                              value: _value,
                              items: data
                                  .map<DropdownMenuItem<String>>(
                                    (x) => DropdownMenuItem(
                                      child: Text(x),
                                      value: '{$x}',
                                    ),
                              )
                                  .toList(),

                              onChanged: (val) => setState(() {
                                _value = val;

                              }),
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