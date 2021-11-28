import 'package:flutter/material.dart';
import 'package:random_users/core/resources/drawables.dart';

class ErrorWhileLoading extends StatelessWidget {
  final VoidCallback onUpdate;

  ErrorWhileLoading(this.onUpdate);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Drawables.getSvg(Drawables.NETWORK_CONNECTIONS) ?? Container(),
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              "Check your internet connection",
              style: Theme.of(context)
                  .textTheme
                  .headline1
                  ?.copyWith(fontSize: 16),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: MaterialButton(
              onPressed: onUpdate,
              child: Text(
                "Try again",
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    ?.copyWith(color: Colors.green[500]),
              ),
            ),
          )
        ],
      ),
    );
  }
}
