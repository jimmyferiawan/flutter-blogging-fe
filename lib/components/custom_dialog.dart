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