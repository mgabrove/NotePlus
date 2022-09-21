import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:developer' as developer;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:note_complete/screens/customdialog.dart';

class Social extends StatefulWidget {
  @override
  _Social createState() => _Social();
}

class _Social extends State<Social> {

  Color customRed = Color.fromRGBO(238, 51, 48, 1);

  pressedBack(){
    Navigator.pop(context);
  }

  pressedNewGroup(){

  }
  pressedNewMember(){

  }
  pressedRemoveMember(documents){

  }
  pressedPromoteAdmin(documents){

  }

  String? _groupSelected;
  Future<DocumentSnapshot<Map<String, dynamic>>>? docGroup;
  //bool changed = false;

  groupChanged(String val){
    this._groupSelected = val;
  }
  String get groupSelected => _groupSelected!;

  @override
  Widget build(BuildContext context) {

    /*debugPrint("PROBLEM");
    debugPrint(_groupSelected);
    if(changed == false) {
      Map data = {};
      data = ModalRoute.of(context)!.settings.arguments as Map;
      _groupSelected = data != null ? data['group'] : null;
    }
    Map data = {};
    data = ModalRoute.of(context)!.settings.arguments as Map;
    _groupSelected = data != null ? data['group'] : null;
    changed = true;*/

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
          body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('groups')
                .where('users', arrayContains: FirebaseAuth.instance.currentUser?.uid)
                .where('name', isEqualTo: 'personal')
                .snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                snapshot.data!.docs.map<DropdownMenuItem<String>>((DocumentSnapshot document) {
                  if(_groupSelected == null && document.get('name') == "personal") {
                    groupChanged(document.get('id'));
                  }
                }).toList();
                return ListView(
                  children: <Widget>[
                    Row(
                        children: <Widget>[
                          Expanded(
                            child: OutlinedButton(
                              child: Text("New Group"),
                              onPressed: pressedNewGroup,
                            ),
                          ),
                        ]
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
                                        groupChanged(valueSelectedByUser!);
                                        setState(() {
                                          //_groupSelected = valueSelectedByUser;
                                        });
                                      },
                                      hint: Text('Choose group'),
                                      items: snapshot.data!.docs.map<DropdownMenuItem<String>>((DocumentSnapshot document) {
                                        if(_groupSelected == null && document.get('name') != "personal") {
                                          _groupSelected = document.get('id');
                                        }
                                        return DropdownMenuItem<String>(
                                          value: document.get('id'),
                                          child: new Text(document.get('name')),
                                        );
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
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('groups')
                          .where('id', isEqualTo: _groupSelected)
                          .snapshots(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return ListView(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            children: snapshot.data!.docs.map<Container>((documents) {
                              return Container(
                                  child: ListView(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    children: documents.get('users').map<Row>((doc) {
                                      debugPrint(doc);
                                return Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 6, // 20%
                                        child: Column(
                                          children: <Widget>[
                                            Align(
                                                alignment: Alignment
                                                    .centerLeft,
                                                child: Padding(
                                                  padding: EdgeInsets
                                                      .fromLTRB(10, 15, 15,
                                                      1),
                                                  child: Text(doc.toString()),
                                                )
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4, // 60%
                                        child: Row(
                                          children: <Widget>[
                                            OutlinedButton(
                                              child: Icon(CupertinoIcons.chevron_compact_up),
                                              onPressed: () =>
                                                  pressedPromoteAdmin(
                                                      documents),
                                            ),
                                            Visibility(
                                              //visible: documents.contains(FirebaseAuth.instance.currentUser?.uid) ? true : false,
                                              child: OutlinedButton(
                                                child: Icon(Icons.remove,
                                                  color: Colors.red,),
                                                onPressed: () async {
                                                  var pressedButton = await showDialog<
                                                      bool>(
                                                      context: context,
                                                      builder: (
                                                          BuildContext context) {
                                                        return CustomDialog(
                                                            "Are you sure\nyou want to delete this note?",
                                                            "Yes", "No");
                                                      }
                                                  );
                                                  if (pressedButton ==
                                                      true) pressedRemoveMember(
                                                      documents);
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]
                                );
                              }).toList()
                              ));
                            }).toList()
                          );
                        }
                      },
                    ),
                    Row(
                        children: <Widget>[
                          Expanded(
                            child: OutlinedButton(
                              child: Text("Add Group Member"),
                              onPressed: pressedNewMember,
                            ),
                          ),
                        ]
                    ),
                  ],
                );
              }
            },
          )

      ),
    );
  }
}