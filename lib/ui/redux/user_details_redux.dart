import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:random_users/core/data/models/UserModel.dart';
import 'package:random_users/core/ui/widgets/user_details/user_details_view.dart';
import 'package:random_users/redux/actions.dart';
import 'package:random_users/redux/app_state.dart';

import 'package:redux/redux.dart';

class UserDetailsRedux extends StatelessWidget {
  final UserModel? selectedUser;

  UserDetailsRedux(this.selectedUser);

  @override
  Widget build(BuildContext context) {
    return StoreConnector(
        builder: (ctx, UserDetailsViewModel vm) => UserDetailsWidget(
              userModel: vm.user,
              onRemove: () {
                vm.onRemove();
                Navigator.pop(context);
              },
              onSave: (String name, String surname, String email) {
                vm.saveUser(name, surname, email);
                Navigator.pop(context);
              },
            ),
        converter: (Store<AppState> store) =>
            UserDetailsViewModel.build(selectedUser, store));
  }
}

class UserDetailsViewModel {
  final UserModel? user;
  final VoidCallback onRemove;
  final Function(UserModel) onSave;

  UserDetailsViewModel(
    this.user,
    this.onRemove,
    this.onSave,
  );

  factory UserDetailsViewModel.build(
    UserModel? selected,
    Store<AppState> store,
  ) {
    return UserDetailsViewModel(
        selected,
        () => store.dispatch(RemoveUserAction(selected!)),
        (user) => store.dispatch(
              SaveUserAction(user),
            ));
  }

  void saveUser(String name, String surname, String email) {
    UserModel user;
    if (this.user == null) {
      user = UserModel(firstName: name, lastName: surname, email: email);
    } else {
      this.user!
        ..firstName = name
        ..lastName = surname
        ..email = email;
      user = this.user!;
    }
    onSave(user);
  }
}
