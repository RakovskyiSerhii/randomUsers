import 'package:flutter/material.dart';

class UserListEmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.account_circle_rounded,
            size: 75,
            color: Colors.green,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "All users have been deleted.\nTry to get random users or create your own.",
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
