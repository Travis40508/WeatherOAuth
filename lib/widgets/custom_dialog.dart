import 'package:flutter/material.dart';
import 'package:weather_oauth/utils/constants.dart';

class CustomDialog extends StatelessWidget {

  final String dialogTitle;
  final String dialogMessage;
  final VoidCallback positiveCallback;

  CustomDialog(this.dialogTitle, this.dialogMessage, this.positiveCallback);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).appBarTheme.color,
      title: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(Constants.defaultPadding),
            child: Icon(Icons.cloud),
          ),
          Text(
            dialogTitle,
            style: Theme.of(context).textTheme.subhead,
          )
        ],
      ),
      content: Text(dialogMessage),
      actions: <Widget>[
        FlatButton(
          color: Theme.of(context).appBarTheme.color,
          child: Text(
            Constants.OK,
            style: Theme.of(context).textTheme.subhead,
          ),
          onPressed: positiveCallback,
        )
      ],
    );
  }
}
