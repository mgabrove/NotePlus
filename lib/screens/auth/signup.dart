import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:note_complete/screens/utils.dart';

class Signup extends StatefulWidget {
  @override
  _Signup createState() => _Signup();
}

class _Signup extends State<Signup> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordRepeatController = TextEditingController();

  Color customRed = Color.fromRGBO(238, 51, 48, 1);

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    passwordRepeatController.dispose();

    super.dispose();
  }

  void login() {
    Navigator.pushReplacementNamed(context, "/login");
  }

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if(!isValid) return;

    try {
      if (passwordController.text.trim() == passwordRepeatController.text.trim()) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        Navigator.pushReplacementNamed(context, "/");
      }
    } on FirebaseAuthException catch (e) {
      print(e);

      Utils.showSnackBar(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: formKey,
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
                  TextFormField(
                    controller: emailController,
                    cursorColor: Colors.white,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(labelText: "Email"),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (email) => email != null && !EmailValidator.validate(email)
                        ? "Enter valid email" : null,
                  ),
                  SizedBox(height: 5),
                  TextFormField(
                    controller: passwordController,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(labelText: "Password"),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => value != null && value.length < 8
                        ? "Enter min. 8 characters" : null,
                    obscureText: true,
                  ),
                  SizedBox(height: 5),
                  TextFormField(
                    controller: passwordRepeatController,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(labelText: "Repeat Password"),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => value != null && value.length < 8
                        ? "Enter min. 8 characters" : value != null && value.trim() != passwordController.text.trim()
                        ? "Passwords do not match" : null,
                    obscureText: true,
                  ),
                  RaisedButton.icon(
                    label: Text("Sign Up"),
                    icon: Icon(Icons.arrow_forward),
                    onPressed: signUp,
                  ),
                  RichText(
                    text: TextSpan(
                        text: 'Already have an account?',
                        style: TextStyle(color: Colors.black, fontSize: 14),
                        children: <TextSpan>[
                          TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = login,
                              text: ' Login',
                              style: TextStyle(color: Colors.blueAccent, fontSize: 14)
                          )
                        ]
                    ),
                  ),
                ],
              ),
          ),
        )
    );
  }
}