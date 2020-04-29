import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final message;

  ErrorDialog({this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("error"),
      content: Text(this.message),
      actions: <Widget>[
        FlatButton(
          child: Text("OK"),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
