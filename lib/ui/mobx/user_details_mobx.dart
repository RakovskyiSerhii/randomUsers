import 'package:flutter/material.dart';
import 'package:random_users/core/data/models/UserModel.dart';
import 'package:random_users/core/ui/widgets/user_details/user_details_view.dart';
import 'package:random_users/mobx/user_details_controller.dart';

class UserDetailsMobx extends StatelessWidget {
  final UserModel? userModel;
  final UserDetailsController _controller = UserDetailsController();

  UserDetailsMobx(this.userModel);

  @override
  Widget build(BuildContext context) {
    return UserDetailsWidget(
      userModel: userModel,
      onRemove: () async {
        await _controller.removeUser(userModel!);
        Navigator.pop(context);
      },
      onSave: (String name, String surname, String email) async {
        await _controller.saveUser(name, surname, email, userModel);
        Navigator.pop(context);
      },
    );
  }
}
