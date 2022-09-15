import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Header extends StatefulWidget implements PreferredSizeWidget {
  final BuildContext contextPassed;
  Header(this.contextPassed);

  @override
  _Header createState() => _Header();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _Header extends State<Header> {
  final Color customRed = Color.fromRGBO(238, 51, 48, 1);

  void logout() {
    FirebaseAuth.instance.signOut();
    Navigator.pushNamed(widget.contextPassed, "/login");
  }
  void register() {
    Navigator.pushNamed(widget.contextPassed, "/register");
  }
  void back() {
    Navigator.pop(widget.contextPassed);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text("Note Complete"),
      backgroundColor: Color.fromRGBO(238, 51, 48, 1),
      elevation: 0.0,
      actions: <Widget>[
        Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: ModalRoute.of(widget.contextPassed)?.settings.name == "/" ?
            GestureDetector(
              onTap: logout,
              child: Icon(
                Icons.logout,
              ),
            ) : ModalRoute.of(widget.contextPassed)?.settings.name == "/login" ?
            GestureDetector(
              onTap: register,
              child: Icon(
                Icons.app_registration,
              ),
            ) :
            GestureDetector(
              onTap: back,
              child: Icon(
                Icons.arrow_back,
              ),
            )
        ),
      ],
    );
  }
}