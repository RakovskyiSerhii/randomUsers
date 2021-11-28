import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:random_users/core/data/models/UserModel.dart';
import 'package:random_users/core/router/app_routing_names.dart';
import 'package:random_users/core/ui/widgets/progress_indicator.dart';
import 'package:random_users/core/ui/widgets/remove_user_snackbar.dart';
import 'package:random_users/core/ui/widgets/user_item_widget.dart';
import 'package:random_users/core/ui/widgets/user_list/app_bar.dart';
import 'package:random_users/core/ui/widgets/user_list/user_list_empty_state.dart';
import 'package:random_users/mobx/user_list_controller.dart';

class UserListMobx extends StatelessWidget {
  final UserListController _controller = UserListController()
    ..loadUsersFromDb();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getUserListAppBar(context,
          () => showRemoveUserSnackBar(context, _controller.refreshUsers)),
      body: Observer(
        builder: (_) {
          final list = _controller.users;
          return Stack(
            children: [
              _controller.isLoading
                  ? ProgressBar()
                  : _getUserList(context, list ?? []),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: FloatingActionButton(
                    onPressed: () {
                      openUser(null, context);
                    },
                    child: Icon(CupertinoIcons.plus),
                    backgroundColor: Colors.green[500],
                  ),
                ),
              )
            ],
          );
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
                onSlide: () => _controller.removeUser(user),
              );
            },
            itemCount: list.length,
          );
  }

  void openUser(UserModel? user, BuildContext context) async {
    await Navigator.of(context)
        .pushNamed(AppRoutes.USER_DETAILS_SCREEN, arguments: user);
    _controller.loadUsersFromDb();
  }
}
