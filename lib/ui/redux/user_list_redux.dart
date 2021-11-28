import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:random_users/bloc/user_list/user_list_bloc.dart';
import 'package:random_users/core/data/models/UserModel.dart';
import 'package:random_users/core/router/app_routing_names.dart';
import 'package:random_users/core/ui/widgets/progress_indicator.dart';
import 'package:random_users/core/ui/widgets/remove_user_snackbar.dart';
import 'package:random_users/core/ui/widgets/user_item_widget.dart';
import 'package:random_users/core/ui/widgets/user_list/app_bar.dart';
import 'package:random_users/core/ui/widgets/user_list/user_list_empty_state.dart';
import 'package:random_users/redux/actions.dart';
import 'package:random_users/redux/app_state.dart';

class UserListRedux extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, UserListViewModel>(
      onInit: (store) => store.dispatch(GetListFromDBAction()),
      builder: (ctx, vm) {
        return Scaffold(
          appBar: getUserListAppBar(
              context, () => showRemoveUserSnackBar(context, vm.refreshUsers)),
          body: Stack(
            children: [
              vm.isLoading ? ProgressBar() : _getUserList(context, vm),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: FloatingActionButton(
                    onPressed: () {
                      openUser(null, context, vm);
                    },
                    child: Icon(CupertinoIcons.plus),
                    backgroundColor: Colors.green[500],
                  ),
                ),
              )
            ],
          ),
        );
      },
      converter: (state) {
        return UserListViewModel(
            users: state.state.users ?? [],
            isLoading: state.state.isLoading,
            removeUser: (user) {
              state.dispatch(RemoveUserAction(user));
            },
            refreshUsers: () {
              state.dispatch(RefreshUsersAction());
            },
            loadUsers: () => state.dispatch(GetListFromDBAction()));
      },
    );
  }

  Widget _getUserList(BuildContext context, UserListViewModel vm) {
    return vm.users.length == 0
        ? UserListEmptyState()
        : ListView.builder(
            itemBuilder: (_, position) {
              final user = vm.users[position];
              return UserItemWidget(
                user: user,
                onUserClick: () => openUser(user, context, vm),
                onSlide: () => vm.removeUser(user),
              );
            },
            itemCount: vm.users.length,
          );
  }

  void openUser(
      UserModel? user, BuildContext context, UserListViewModel vm) async {
    await Navigator.of(context)
        .pushNamed(AppRoutes.USER_DETAILS_SCREEN, arguments: user);
    vm.loadUsers();
    // _bloc.add(LoadUsersEvent());
  }
}

class UserListViewModel {
  final List<UserModel> users;
  final Function(UserModel) removeUser;
  final VoidCallback refreshUsers;
  final VoidCallback loadUsers;
  final bool isLoading;

  UserListViewModel({
    required this.users,
    required this.removeUser,
    required this.refreshUsers,
    required this.isLoading,
    required this.loadUsers,
  });
}
