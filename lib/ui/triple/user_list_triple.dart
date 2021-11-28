import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:random_users/core/data/models/UserModel.dart';
import 'package:random_users/core/router/app_routing_names.dart';
import 'package:random_users/core/ui/widgets/progress_indicator.dart';
import 'package:random_users/core/ui/widgets/remove_user_snackbar.dart';
import 'package:random_users/core/ui/widgets/user_item_widget.dart';
import 'package:random_users/core/ui/widgets/user_list/app_bar.dart';
import 'package:random_users/core/ui/widgets/user_list/user_list_empty_state.dart';
import 'package:random_users/triple/user_list_store.dart';

class UserListTriple extends StatelessWidget {
  final _store = UserListStore()..loadUsersFromDb();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getUserListAppBar(
          context, () => showRemoveUserSnackBar(context, _store.refreshUsers)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openUser(null, context);
        },
        child: Icon(CupertinoIcons.plus),
        backgroundColor: Colors.green[500],
      ),
      body: TripleBuilder(
        store: _store,
        builder: (_, Triple<Exception, UserListState> triple) {
          if (triple.isLoading)
            return ProgressBar();
          else
            return _getUserList(context, triple.state.value ?? []);
        },
      ),
    );
  }

  Widget _getUserList(BuildContext context, List<UserModel> list) {
    return list.length == 0
        ? UserListEmptyState()
        : ListView.builder(
            itemBuilder: (_, position) {
              final user = list[position];
              return UserItemWidget(
                user: user,
                onUserClick: () => openUser(user, context),
                onSlide: () => _store.removeUser(user),
              );
            },
            itemCount: list.length,
          );
  }

  void openUser(UserModel? user, BuildContext context) async {
    await Navigator.of(context)
        .pushNamed(AppRoutes.USER_DETAILS_SCREEN, arguments: user);
    _store.loadUsersFromDb();
  }
}
