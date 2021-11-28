import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_users/bloc/user_list/user_list_bloc.dart';
import 'package:random_users/core/data/models/UserModel.dart';
import 'package:random_users/core/router/app_routing_names.dart';
import 'package:random_users/core/ui/widgets/progress_indicator.dart';
import 'package:random_users/core/ui/widgets/remove_user_snackbar.dart';
import 'package:random_users/core/ui/widgets/user_item_widget.dart';
import 'package:random_users/core/ui/widgets/user_list/user_list_empty_state.dart';

class UserListScreen extends StatelessWidget {
  final _bloc = UserListBloc();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserListBloc, UserListState>(
      bloc: _bloc,
      buildWhen: (prev, state) =>
          !(state is UserOpenState || state is CreateUserState),
      builder: (blocContext, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green[500],
            title: Text(
              "Random users",
              style: Theme.of(context)
                  .textTheme
                  .headline1!
                  .copyWith(color: Colors.white, fontSize: 22),
            ),
            actions: [
              IconButton(
                onPressed: () => showRemoveUserSnackBar(context, () => _bloc.add(RefreshUsersEvent())),
                icon: Icon(
                  CupertinoIcons.arrow_3_trianglepath,
                  color: Colors.white,
                ),
              )
            ],
          ),
          body: Stack(
            children: [
              state is UserListLoadingState
                  ? ProgressBar()
                  :
              _getUserList(
                      (state as UserListRetrievedState).list,
                      context,
                    ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: FloatingActionButton(
                    onPressed: () {
                      _bloc.add(CreateUserEvent());
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
      listener: (BuildContext context, UserListState? state) {
        if (state == null) return;
        if (state is UserOpenState) {
          openUser(state.userModel, context);
        } else if (state is CreateUserState) {
          openUser(null, context);
        }
      },
    );
  }

  Widget _getUserList(List<UserModel> userList, BuildContext context) {
    return userList.length == 0
        ? UserListEmptyState()
        : ListView.builder(
            itemBuilder: (_, position) {
              final user = userList[position];
              return UserItemWidget(
                user: user,
                onUserClick: () => _bloc.add(OpenUserEvent(user)),
                onSlide: () => _bloc.add(RemoveUserEvent(user)),
              );
            },
            itemCount: userList.length,
          );
  }

  void openUser(UserModel? user, BuildContext context) async {
    await Navigator.of(context)
        .pushNamed(AppRoutes.USER_DETAILS_SCREEN, arguments: user);
    _bloc.add(LoadUsersEvent());
  }
}
