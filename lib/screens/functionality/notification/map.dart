import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_complete/screens/header.dart';

class Map extends StatefulWidget {
  @override
  _Map createState() => _Map();
}

class _Map extends State<Map>{

  void pressedCreate() {
    Navigator.pushNamed(context, '/create', arguments: {'group': _groupSelected});
  }

  Color customRed = Color.fromRGBO(238, 51, 48, 1.0);

  Completer<GoogleMapController> _controller = Completer();
  var mapController;

  static const LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller){
    mapController = controller;
    controller.setMapStyle(([
      {
        "featureType": "poi",
        "stylers": [{ "visibility": "off" }]
      },
      {
        "featureType": "transit",
        "stylers": [{ "visibility": "off" }]
      },
    ]).toString());
    moveCameraToUserLocation();
  }

  late LatLng currentPostion;

  LatLng currentPosition() {
    return currentPostion;
  }

  _getUserLocation() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    permission = await Geolocator.requestPermission();
    if( permission == LocationPermission.denied){
      //nothing
    }

    var position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      currentPostion = LatLng(position.latitude, position.longitude);
    });
  }

  void moveCameraToUserLocation() async {
    await _getUserLocation();
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: currentPosition(),
          zoom: 18,
        ),
      ),
    );
  }

  moveMarker() {
    setState(() {
      moveMode = true;
    });
    readNotes();
  }

  final controller = TextEditingController();

  List<Marker> _markers = <Marker>[];
  String _selectedMarker = '';
  bool moveMode = false;

  readNotes() {
    FirebaseFirestore.instance
        .collection('notes')
        .where('groupId', isEqualTo: _groupSelected)
        .get()
        .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            setState(() {
              _markers.add(Marker(
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  _selectedMarker == doc["id"] ? BitmapDescriptor.hueBlue : BitmapDescriptor.hueRed,
                ),
                onTap: () {
                  setState(() {
                    _selectedMarker = doc["id"];
                  });
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: 260,
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('notes')
                              .doc(_selectedMarker)
                              .snapshots(),
                          builder: (context, AsyncSnapshot snapshot) {
                            var document = snapshot.data;
                            if (!snapshot.hasData) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              controller.text = document["note"];
                              return Container(
                                color: Colors.white,
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(document["title"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                                      Text("lat: " + document["lat"].toString() + ", long: " + document["long"].toString(), style: TextStyle(fontSize: 10),),
                                      OutlinedButton(onPressed: moveMarker, child: Text("Move note", style: TextStyle(color: Colors.black),)),
                                      SizedBox(height: 5),
                                      TextField(
                                        decoration: InputDecoration.collapsed(
                                          hintText: "",
                                          border: InputBorder.none,
                                        ),
                                        controller: controller,
                                        enabled: false,
                                        maxLines: 5,
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.red,
                                                ),
                                                child: const Text('Edit'),
                                                onPressed: () => Navigator.pop(context),
                                              ),
                                            ),
                                            SizedBox(width: 10,),
                                            Expanded(
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.red,
                                                ),
                                                child: const Text('Collapse'),
                                                onPressed: () => Navigator.pop(context),
                                              ),
                                            ),
                                          ]
                                      ),
                                    ],
                                  ),
                                )
                              );
                            }
                          },
                        )
                      );
                    },
                  );
                },
                markerId: MarkerId(doc["id"]),
                position: LatLng(doc["lat"], doc["long"]),
                //icon: BitmapDescriptor.defaultMarker,
                draggable: false,
                zIndex: 1,
              ));
            });
          });
        });
  }

  pressedBack(){
    Navigator.pop(context);
  }

  String? _groupSelected;

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
          body: Container(
            child: Stack(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: GoogleMap(
                    mapToolbarEnabled: false,
                    markers: Set<Marker>.of(_markers),
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(0,0),
                      zoom: 0.0,
                    ),
                    //markers: Set<Marker>.of(markers.values),
                  ),
                ),
                Column(
                  children: <Widget>[
                    Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: FloatingActionButton.extended(
                            backgroundColor: Color.fromRGBO(238, 51, 48, 1),
                            heroTag: "btn1",
                            onPressed: moveCameraToUserLocation,
                            label: Text(""),
                            icon: Icon(Icons.gps_fixed_rounded),
                          ),
                        )
                    ),
                    Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                          child: FloatingActionButton.extended(
                            backgroundColor: Color.fromRGBO(238, 51, 48, 1),
                            heroTag: "btn2",
                            onPressed: pressedCreate,
                            label: Text(""),
                            icon: Icon(Icons.create),
                          ),
                        )
                    ),
                  ],
                ),
                Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 150, 10),
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
                              color: Colors.white,
                              child: DropdownButtonFormField<String>(
                                onChanged: (valueSelectedByUser) {
                                  setState(() {
                                    _markers = <Marker>[];
                                    _groupSelected = valueSelectedByUser;
                                    readNotes();
                                  });
                                },
                                hint: Text('Choose group'),
                                items: snapshot.data!.docs.map<DropdownMenuItem<String>>((DocumentSnapshot document) {
                                  if(_groupSelected == null && document.get('name') == "personal") {
                                      _groupSelected = document.get('id');
                                      _markers = <Marker>[];
                                      readNotes();
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
                    )
                ),
              ]
            )
          ),
        ),
      );
    }
}