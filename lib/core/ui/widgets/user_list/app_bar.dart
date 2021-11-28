import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

PreferredSizeWidget getUserListAppBar(BuildContext context, VoidCallback callback) {
  return AppBar(
    backgroundColor: Colors.green[500],
    title: Text(
      "Random users",
      style: Theme.of(context)
          .textTheme
          .headline1!
          .copyWith(color: Colors.white, fontSize: 22),
    ),
    actions: [
      IconButton(
        onPressed: callback,
        icon: Icon(
          CupertinoIcons.arrow_3_trianglepath,
          color: Colors.white,
        ),
      )
    ],
  );
}