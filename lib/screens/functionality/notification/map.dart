import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'note.dart';

class Map extends StatefulWidget {
  @override
  _Map createState() => _Map();
}

class _Map extends State<Map>{

  Color customRed = Color.fromRGBO(238, 51, 48, 1.0);

  Completer<GoogleMapController> _controller = Completer();
  var mapController;

  static const LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller){
    readNotes();
    mapController = controller;
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
          zoom: 13,
        ),
      ),
    );
  }

  List<Marker> _markers = <Marker>[];

  readNotes() {
    FirebaseFirestore.instance
        .collection('notes')
        .get()
        .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            _markers.add(Marker(
              markerId:MarkerId(doc["id"]),
              position: LatLng(doc["lat"], doc["long"]),
              icon: BitmapDescriptor.defaultMarker,
              draggable: false,
              zIndex: 1,
            ));
          });
        });
  }

    @override
    Widget build(BuildContext context) {

      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text("Note Complete - Map"),
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
          body: GoogleMap(
            markers: Set<Marker>.of(_markers),
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LatLng(0,0),
              zoom: 0.0,
            ),
            //markers: Set<Marker>.of(markers.values),
          ),
        ),
      );
      /* return Container(
      color: Color.fromRGBO(236, 244, 248, 1),
      child: OutlinedButton(
        child: Text("MAP"),
        onPressed: pressedBack,
      ),
    );*/
    }
}