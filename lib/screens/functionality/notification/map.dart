import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:geolocator/geolocator.dart';

class Map extends StatefulWidget {


  @override
  _Map createState() => _Map();
}

class _Map extends State<Map>{

  LatLng _currentPosition = LatLng(0, 0);

  Completer<GoogleMapController> _controller = Completer();
  var mapController;

  static const LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller){
    //_controller.complete(controller);
    mapController = controller;
    moveCameraToUserLocation();
  }

  moveCameraToUserLocation() async {
    Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.lowest, forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: _currentPosition,
              zoom: 10,
            ),
          ),
        );
      });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Map Notes'),
          backgroundColor: Colors.red,
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _currentPosition,
            zoom: 0.0,
          ),
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