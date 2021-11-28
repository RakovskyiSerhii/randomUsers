import 'package:flutter/material.dart';
import 'package:random_users/core/router/app_routing_names.dart';

class LoadingUsersComplete extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Downloading successful! You free to go :)",
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(fontSize: 14),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: MaterialButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, AppRoutes.USER_LIST_SCREEN, (route) => false);
              },
              child: Text(
                "Go to list",
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(fontSize: 18, color: Colors.green[500]),
              ),
            ),
          )
        ],
      ),
    );
  }
}
