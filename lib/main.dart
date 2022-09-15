import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:note_complete/screens/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:note_complete/screens/functionality/home.dart';
import 'package:note_complete/screens/functionality/notification/create.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_complete/screens/functionality/notification/map.dart';
import 'package:note_complete/screens/functionality/notification/list.dart';
import 'package:note_complete/screens/functionality/social/social.dart';
import 'package:note_complete/screens/auth/login.dart';
import 'package:note_complete/screens/auth/signup.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/' : (BuildContext context) => Wrapper(),
        '/login' : (BuildContext context) => Login(),
        '/signUp' : (BuildContext context) => Signup(),
        '/map' : (BuildContext context) => Map(),
        '/list' : (BuildContext context) => List(),
        '/create' : (BuildContext context) => Create(),
        '/social' : (BuildContext context) => Social(),
      },
    );
  }
}
