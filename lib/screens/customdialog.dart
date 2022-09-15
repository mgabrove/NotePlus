import 'package:flutter/material.dart';
class CustomDialog extends StatelessWidget {
  final String text;
  final String buttonYes;
  final String buttonNo;

  CustomDialog(this.text, this.buttonYes, this.buttonNo);

  dialogContent(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: const Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // To make the card compact
        children: <Widget>[
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: text,
                style: TextStyle(color: Colors.black, fontSize: 20),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                textColor: Colors.green,
                child: Text(buttonYes),
              ),
              SizedBox(width: 10),
              RaisedButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                textColor: Colors.red,
                child: Text(buttonNo),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
}