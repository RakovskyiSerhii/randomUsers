import 'package:flutter/material.dart';

class LoadingUsersProgressWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            backgroundColor: Colors.white,
            valueColor: AlwaysStoppedAnimation(Colors.green[500]),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              "Downloading users. Please stand by ... ",
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
