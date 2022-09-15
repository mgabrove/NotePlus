import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_complete/screens/header.dart';

class Login extends StatefulWidget {
  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Color customRed = Color.fromRGBO(238, 51, 48, 1);

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  void signup() {
    Navigator.pushReplacementNamed(context, "/signUp");
  }

  Future signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Navigator.pushReplacementNamed(context, "/");
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 40),
              Icon(Icons.note_alt,
                  color: Color.fromRGBO(238, 51, 48, 1),
                  size: MediaQuery.of(context).orientation == Orientation.portrait ? 250 : 50
              ),
              SizedBox(height: 5),
              TextField(
                controller: emailController,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(labelText: "Email"),
              ),
              SizedBox(height: 5),
              TextField(
                controller: passwordController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true,
              ),
              RaisedButton.icon(
                label: Text("Login"),
                icon: Icon(Icons.lock_open),
                onPressed: signIn,
              ),
              RichText(
                text: TextSpan(
                    text: 'Don\'t have an account?',
                    style: TextStyle(color: Colors.black, fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(text: ' Sign Up',
                          style: TextStyle(color: Colors.blueAccent, fontSize: 14)
                      )
                    ]
                ),
              ),
          ],
        ),
      )
    );
  }
}