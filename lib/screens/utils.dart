import 'package:flutter/material.dart';

class Utils {
  static var messengerKey = GlobalKey<ScaffoldMessengerState>();
  static showSnackBar(String? text) {
    if(text == null) return;

    final snackBar = SnackBar(content: Text(text), backgroundColor: Color.fromRGBO(238, 51, 48, 1));

    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}