import 'package:flutter/material.dart';

void showRemoveUserSnackBar(BuildContext context, VoidCallback refresh) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
    content: Text(
      "Remove all users, and get some new random?",
      style: Theme.of(context)
          .textTheme
          .subtitle1!
          .copyWith(fontSize: 16, color: Colors.white),
    ),
    action: SnackBarAction(
      onPressed: refresh,
      label: "Yes",
      textColor: Colors.green,
    ),
  ));
}
