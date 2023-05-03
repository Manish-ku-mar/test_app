import 'package:flutter/material.dart';

class ShowError {
  Future showErrorDialog(BuildContext context, String message) {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text("Something Went Wrong"),
            content: Text(message),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Okay"))
            ],
          );
        });
  }
}
