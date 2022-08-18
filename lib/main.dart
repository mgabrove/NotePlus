import 'package:flutter/material.dart';
import 'package:note_complete/screens/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:note_complete/screens/functionality/home.dart';
import 'package:note_complete/screens/functionality/notification/create.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //home: Wrapper(),
      routes: {
        '/' : (BuildContext context)=>Home(),
        '/create' : (BuildContext context)=>Create(),
        //'/register' : (BuildContext context)=>Login(),
      },
    );
  }
}
