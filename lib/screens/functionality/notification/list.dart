import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_complete/screens/customdialog.dart';

class List extends StatefulWidget {
  @override
  _List createState() => _List();
}

class _List extends State<List> {

  Color customRed = Color.fromRGBO(238, 51, 48, 1);

  pressedBack(){
    Navigator.pop(context);
  }

  bool isCopyMode = false;
  pressedDelete(documents) async{
      final docCreate = FirebaseFirestore.instance.collection('notes');
      await docCreate.doc(documents['id']).delete();
  }
  pressedCopy(documents){
    setState(() {
      id = documents['id'];
      title = documents['title'];
      note = documents['note'];
      long = documents['long'];
      lat = documents['lat'];
      groupId = documents['groupId'];
      isCopyMode = true;
    });
  }
  pressedPaste(String val) async{
    setState(() {
      isCopyMode = false;
    });
    debugPrint(val);
    final docCreate = FirebaseFirestore.instance.collection('notes').doc();
    final json = {
      'id': docCreate.id,
      'title': title,
      'note': note,
      'long': long,
      'lat': lat,
      'groupId': val,
    };
    await docCreate.set(json);
  }

  //copy val
  var id;
  var title;
  var note;
  var long;
  var lat;
  var groupId;

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
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView(
                children: snapshot.data!.docs.map<Widget>((documents) {
                  return Container(
                      child: ExpansionTile(
                      iconColor: CupertinoColors.systemGrey,
                      backgroundColor: CupertinoColors.extraLightBackgroundGray,
                      collapsedBackgroundColor: Colors.white,
                      collapsedTextColor: Colors.black87,
                      textColor: Colors.black87,
                      trailing: Visibility(
                          visible: isCopyMode,
                          child: OutlinedButton(
                            child: Icon(Icons.paste),
                            onPressed: () async {
                              var pressedButton = await showDialog<bool>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CustomDialog("Are you sure you want to\npaste to this group?", "Yes", "No");
                                  }
                              );
                              if (pressedButton == true) pressedPaste(documents['id']);
                              else setState(() {
                                isCopyMode = false;
                              });
                            },
                          ),
                      ),
                      title: Text(documents['name'], style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
                      children: <Widget>[
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('notes')
                              .where('groupId', isEqualTo: documents['id'])
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
                                children: snapshot.data!.docs.map<Widget>((documents1) {
                                  return Container(
                                      child: ExpansionTile(
                                        iconColor: CupertinoColors.systemGrey,
                                        backgroundColor: CupertinoColors.extraLightBackgroundGray,
                                        collapsedBackgroundColor: Colors.white,
                                        collapsedTextColor: Colors.black87,
                                        textColor: Colors.black87,
                                        title: Text(documents1['title']),
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                flex: 8, // 20%
                                                child: Column(
                                                  children: <Widget>[
                                                    Align(
                                                        alignment: Alignment.centerLeft,
                                                        child: Padding(
                                                          padding: EdgeInsets.fromLTRB(10, 1, 1, 1),
                                                          child: Text('Text: ' + documents1['note']),
                                                        )
                                                    ),
                                                    Align(
                                                        alignment: Alignment.centerLeft,
                                                        child: Padding(
                                                          padding: EdgeInsets.fromLTRB(10, 1, 1, 1),
                                                          child: Text('Lat: ' + documents1['lat'].toString() + ', Long: ' + documents1['long'].toString()),
                                                        )
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2, // 60%
                                                child: Column(
                                                  children: <Widget>[
                                                    OutlinedButton(
                                                      child: Icon(Icons.copy),
                                                      onPressed: () => pressedCopy(documents1),
                                                    ),
                                                    Visibility(
                                                      visible: documents['admins'].contains(FirebaseAuth.instance.currentUser?.uid) ? true : false,
                                                        child: OutlinedButton(
                                                          child: Icon(CupertinoIcons.delete, color: Colors.red,),
                                                          onPressed: () async {
                                                            var pressedButton = await showDialog<bool>(
                                                                context: context,
                                                                builder: (BuildContext context) {
                                                                  return CustomDialog("Are you sure\nyou want to delete this note?", "Yes", "No");
                                                                }
                                                            );
                                                            if (pressedButton == true) pressedDelete(documents1);
                                                          },
                                                        ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),

                                        ],
                                      )
                                  );
                                }).toList(),
                              );
                            }
                          },
                        )
                      ],
                    )
                  );
                }).toList(),
              );
            }
          },
        )
      ),
    );
  }
}