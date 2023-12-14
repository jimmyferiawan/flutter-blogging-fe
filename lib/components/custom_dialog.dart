import 'package:flutter/material.dart';

void showCustomDialog(BuildContext context, String message) {
    showDialog(
        context: context, 
        builder: (BuildContext context) {
            BuildContext dialogContext = context;
            return AlertDialog(
                title: const Text('Oops!'),
                content: Text(message),
                actions: <Widget>[
                    TextButton(
                        onPressed: () {
                            return Navigator.pop(dialogContext);
                        },
                        child: const Text('OK'),
                    ),
                ],
            );
        }
    );
}

void showDialogCustomAction({required BuildContext context, String? dialogMessage, String? dialogTitle, String? dialogActionText, void Function(BuildContext)? dialogAction}) {
    showDialog(
        context: context, 
        builder: (BuildContext context) {
            BuildContext dialogContext = context;
            return AlertDialog(
                title: Text(dialogTitle!),
                content: Text(dialogMessage!),
                actions: <Widget>[
                    TextButton(
                        onPressed: () async{
                            dialogAction!(dialogContext);
                        },
                        child: Text(dialogActionText!),
                    ),
                ],
            );
        }
    );
}