import 'package:flutter/material.dart';
import 'package:note_complete/screens/functionality/home.dart';
import 'package:note_complete/screens/auth/login.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    body: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError){
          return Center(child: Text("Something went wrong."));
        } else if (snapshot.hasData){
          return Home();
        } else {
          return Login();
        }
      },
    ),
  );
}
