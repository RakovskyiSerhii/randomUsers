import 'package:flutter/material.dart';
import 'package:random_users/core/data/models/UserModel.dart';

class UserItemWidget extends StatelessWidget {
  final UserModel user;
  final VoidCallback onUserClick;
  final VoidCallback onSlide;

  UserItemWidget({
    required this.user,
    required this.onUserClick,
    required this.onSlide,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
      child: Dismissible(
        key: Key(user.id!.toString()),
        onDismissed: (direction) => onSlide(),
        child: Card(
          child: ListTile(
            onTap: onUserClick,
            leading: user.icon != null
                ? Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(image: NetworkImage(user.icon!)),
                    ),
                  )
                : Container(
                    width: 45,
                    height: 45,
                    child: Icon(Icons.account_circle_sharp),
                  ),
            title: Text(user.firstName + " " + user.lastName),
            subtitle: Text(user.email),
          ),
        ),
      ),
    );
  }
}
