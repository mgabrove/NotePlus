import 'package:flutter/material.dart';

class Provider extends ChangeNotifier { // create a common file for data
  int _menuChoice = 0;

  int get intg => _menuChoice;

  void setString(int intg) {
    _menuChoice = intg;
    notifyListeners();
  }
}