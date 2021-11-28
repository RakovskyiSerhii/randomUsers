import 'package:flutter/material.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:random_users/core/data/models/UserModel.dart';
import 'package:random_users/core/ui/widgets/user_details/user_details_view.dart';
import 'package:random_users/triple/user_details_store.dart';

class UserDetailsTriple extends StatelessWidget {
  final UserDetailsStore _store;

  UserDetailsTriple(UserModel? userModel)
      : _store = UserDetailsStore(userModel);

  @override
  Widget build(BuildContext context) {
    return ScopedBuilder(
      store: _store,
      onState: (_, UserDetailsState state) {
        final userModel = state.value;
        return UserDetailsWidget(
          userModel: userModel,
          onRemove: () async {
            await _store.removeUser(userModel!);
            Navigator.pop(context);
          },
          onSave: (String name, String surname, String email) async {
            await _store.saveUser(name, surname, email);
            Navigator.pop(context);
          },
        );
      },
    );
  }
}
