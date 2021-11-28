import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:random_users/core/ui/widgets/error_while_loading.dart';
import 'package:random_users/core/ui/widgets/loadingUsers_complete.dart';
import 'package:random_users/core/ui/widgets/loading_users_progress.dart';
import 'package:random_users/mobx/first_entry_controller.dart';

class FirstEntryMobx extends StatelessWidget {
  final FirstEntryController _controller = FirstEntryController()..loadUsers();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Observer(
        builder: (_) {
          if (_controller.isLoading) {
            return LoadingUsersProgressWidget();
          }
          else if (_controller.isErrorWhileLoading) {
            return ErrorWhileLoading(_controller.loadUsers);
          }
          return LoadingUsersComplete();
        },
      ),
    );
  }
}
