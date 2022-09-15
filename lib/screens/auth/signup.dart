import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_complete/screens/header.dart';

class Signup extends StatefulWidget {
  @override
  _Signup createState() => _Signup();
}

class _Signup extends State<Signup> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Color customRed = Color.fromRGBO(238, 51, 48, 1);

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  void login() {
    Navigator.pushReplacementNamed(context, "/login");
  }

  Future signIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Note Complete"),
        backgroundColor: Color.fromRGBO(238, 51, 48, 1),
        elevation: 0.0,
        actions: <Widget>[
          RichText(
            text: TextSpan(
                text: 'Don\'t have an account?',
                style: TextStyle(color: Colors.black, fontSize: 20),
                children: <TextSpan>[
                  TextSpan(text: ' Sign up',
                      style: TextStyle(color: Colors.blueAccent, fontSize: 20)
                  )
                ]
            ),
          ),
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: login,
                child: Icon(
                  Icons.login,
                ),
              )
          ),
        ],
      ),
      body: Container(
          width: double.infinity,
          height: 500,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              TextField(
                controller: emailController,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(labelText: "Email"),
              )
            ],
          )
      ),
    );
  }
}