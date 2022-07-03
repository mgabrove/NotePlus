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

  Color customRed = Color.fromRGBO(238, 51, 48, 1);

  Completer<GoogleMapController> _controller = Completer();
  var mapController;

  static const LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller){
    //_controller.complete(controller);
    mapController = controller;
    moveCameraToUserLocation();
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

  void moveCameraToUserLocation() async {
    await _getUserLocation();
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: currentPosition(),
          zoom: 10,
        ),
      ),
    );
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
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: LatLng(0,0),
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