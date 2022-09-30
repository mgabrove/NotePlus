import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:developer' as developer;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:note_complete/screens/customdialog.dart';
import 'package:note_complete/screens/customform.dart';

class Social extends StatefulWidget {
  @override
  _Social createState() => _Social();
}

class _Social extends State<Social> {
  final groupController = TextEditingController();

  Color customRed = Color.fromRGBO(238, 51, 48, 1);

  pressedBack(){
    Navigator.pop(context);
  }

  pressedNewGroup(String pressedValue) async{
    final docGrp = FirebaseFirestore.instance.collection('groups').doc();
    final json = {
      'id': docGrp.id,
      'admins': [FirebaseAuth.instance.currentUser?.uid],
      'users': [FirebaseAuth.instance.currentUser?.uid],
      'pending': [],
      'name': pressedValue,
    };
    await docGrp.set(json);
  }
  pressedLeaveGroup(documents){
    var ref = FirebaseFirestore.instance.collection('groups').doc(_groupSelected);
    ref.update({
      'users': FieldValue.arrayRemove([documents]),
      'admins': FieldValue.arrayRemove([documents]),
      'pending': FieldValue.arrayRemove([documents]),
    });
  }
  pressedNewMember(String pressedValue) async{
    final docNew = FirebaseFirestore.instance.collection('groups').doc(_groupSelected).update({'users': FieldValue.arrayUnion([pressedValue])});
  }
  pressedRemoveMember(documents){
    var ref = FirebaseFirestore.instance.collection('groups').doc(_groupSelected);
    ref.update({
      'users': FieldValue.arrayRemove([documents]),
    });
  }
  pressedPromoteAdmin(documents){
    var ref = FirebaseFirestore.instance.collection('groups').doc(_groupSelected);
    ref.update({
      'admins': FieldValue.arrayUnion([documents]),
    });
  }
  pressedAcceptUser(documents){
    var ref = FirebaseFirestore.instance.collection('groups').doc(_groupSelected);
    ref.update({
      'pending': FieldValue.arrayRemove([documents]),
    });
  }
  pressedRejectUser(documents){
    var ref = FirebaseFirestore.instance.collection('groups').doc(_groupSelected);
    ref.update({
      'users': FieldValue.arrayRemove([documents]),
      'pending': FieldValue.arrayRemove([documents]),
    });
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
                              onPressed: () async {
                                var pressedButton = await showDialog<
                                    String>(
                                    context: context,
                                    builder: (
                                        BuildContext context) {
                                      return CustomForm(
                                          "Create Group", "Yes", "No", "group name");
                                    }
                                );
                                if (pressedButton != '') pressedNewGroup(pressedButton!);
                              },
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
                                          _groupSelected = valueSelectedByUser;
                                        });
                                      },
                                      hint: Text('Choose group'),
                                      items: snapshot.data!.docs.map<DropdownMenuItem<String>>((DocumentSnapshot document) {
                                        if(_groupSelected == null && document.get('name') != "personal") {
                                          _groupSelected = document.get('id');
                                        }
                                        return DropdownMenuItem<String>(
                                          value: document.get('id'),
                                          child: new Text(document.get('name'), style: TextStyle(fontWeight: _groupSelected == document.get('id') ? FontWeight.bold : FontWeight.normal),),
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
                                    children: <String>[""].map<Row>((item) {
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
                                                          .fromLTRB(10, 15, 15, 1),
                                                      child: Text("Admins", style: TextStyle(fontWeight: FontWeight.bold),),
                                                    )
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    }).toList() +
                                    documents.get('admins').map<Row>((doc) {
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
                                                      .fromLTRB(10, 15, 15, 1),
                                                  child: Text(
                                                    doc
                                                  ),
                                                )
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4, // 60%
                                        child: Row(
                                          children: <Widget>[

                                          ],
                                        ),
                                      ),
                                    ]
                                );
                              }).toList() +
                                        <String>[""].map<Row>((item) {
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
                                                              .fromLTRB(10, 15, 15, 1),
                                                          child: Text("Users", style: TextStyle(fontWeight: FontWeight.bold),),
                                                        )
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        }).toList() +
                                        List.from((Set.from(documents.get('users')).difference(Set.from(documents.get('admins')))).difference(Set.from(documents.get('pending')))).map<Row>((doc) {
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
                                                                .fromLTRB(10, 15, 15, 1),
                                                            child: Text(
                                                                doc
                                                            ),
                                                          )
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 4, // 60%
                                                  child: Row(
                                                    children: <Widget>[
                                                      Visibility(
                                                        visible: documents.get('admins').contains(FirebaseAuth.instance.currentUser?.uid) ? true : false,
                                                          child: OutlinedButton(
                                                            child: Icon(CupertinoIcons.chevron_compact_up),
                                                            onPressed: () async {
                                                              var pressedButton = await showDialog<
                                                                  bool>(
                                                                  context: context,
                                                                  builder: (
                                                                      BuildContext context) {
                                                                    return CustomDialog(
                                                                        "Are you sure\nyou want to promote this user?",
                                                                        "Yes", "No");
                                                                  }
                                                              );
                                                              if (pressedButton ==
                                                                  true) pressedPromoteAdmin(
                                                                  doc);
                                                            },
                                                          ),
                                                      ),
                                                      Visibility(
                                                        visible: documents.get('admins').contains(FirebaseAuth.instance.currentUser?.uid) ? true : false,
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
                                                                      "Are you sure\nyou want to kick this user?",
                                                                      "Yes", "No");
                                                                }
                                                            );
                                                            if (pressedButton ==
                                                                true) pressedRemoveMember(
                                                                doc);
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ]
                                          );
                                        }).toList()+
                                        <String>[""].map<Row>((item) {
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
                                                              .fromLTRB(10, 15, 15, 1),
                                                          child: Text("Pending", style: TextStyle(fontWeight: FontWeight.bold),),
                                                        )
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        }).toList() +
                                        (documents.get('pending').map<Row>((doc) {
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
                                                                .fromLTRB(10, 15, 15, 1),
                                                            child: Text(
                                                                doc
                                                            ),
                                                          )
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 4, // 60%
                                                  child: Row(
                                                    children: <Widget>[
                                                      Visibility(
                                                        visible: documents.get('admins').contains(FirebaseAuth.instance.currentUser?.uid) ? true : false,
                                                          child: OutlinedButton(
                                                            child: Icon(CupertinoIcons.plus),
                                                            onPressed: () async {
                                                              var pressedButton = await showDialog<
                                                                  bool>(
                                                                  context: context,
                                                                  builder: (
                                                                      BuildContext context) {
                                                                    return CustomDialog(
                                                                        "Are you sure\nyou want to accept this person?",
                                                                        "Yes", "No");
                                                                  }
                                                              );
                                                              if (pressedButton ==
                                                                  true) pressedAcceptUser(
                                                                  doc);
                                                            },
                                                          ),
                                                      ),
                                                      Visibility(
                                                        visible: documents.get('admins').contains(FirebaseAuth.instance.currentUser?.uid) ? true : false,
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
                                                                      "Are you sure\nyou want to reject this person?",
                                                                      "Yes", "No");
                                                                }
                                                            );
                                                            if (pressedButton ==
                                                                true) pressedRejectUser(
                                                                doc);
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ]
                                          );
                                        }).toList()
                                        )
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
                              onPressed: () async {
                                var pressedButton = await showDialog<
                                    String>(
                                    context: context,
                                    builder: (
                                        BuildContext context) {
                                      return CustomForm(
                                          "Add User",
                                          "Yes", "No", "email");
                                    }
                                );
                                if (pressedButton != '') pressedLeaveGroup(docs);
                              },
                            ),
                          ),
                          Expanded(
                            child: OutlinedButton(
                              child: Text("Leave Group"),
                              onPressed: () async {
                                var pressedButton = await showDialog<
                                    bool>(
                                    context: context,
                                    builder: (
                                        BuildContext context) {
                                      return CustomDialog(
                                          "Are you sure\nyou want to leave this group?",
                                          "Yes", "No");
                                    }
                                );
                                if (pressedButton ==
                                    true) pressedLeaveGroup();
                              },
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