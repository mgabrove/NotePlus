import 'package:flutter/material.dart';
class CustomForm extends StatelessWidget {
  final String text;
  final String buttonYes;
  final String buttonNo;
  final String hint;
  final controller = TextEditingController();

  CustomForm(this.text, this.buttonYes, this.buttonNo, this.hint);

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
          Flexible(child: TextFormField(
            controller: controller,
            cursorColor: Colors.white,
            decoration: InputDecoration(labelText: hint),
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  Navigator.of(context).pop(controller.text.trim());
                },
                textColor: Colors.green,
                child: Text(buttonYes),
              ),
              SizedBox(width: 10),
              RaisedButton(
                onPressed: () {
                  Navigator.of(context).pop('');
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