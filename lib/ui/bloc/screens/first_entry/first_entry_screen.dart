import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_users/bloc/user_loading/user_loading_cubit.dart';
import 'package:random_users/core/ui/widgets/error_while_loading.dart';
import 'package:random_users/core/ui/widgets/loadingUsers_complete.dart';
import 'package:random_users/core/ui/widgets/loading_users_progress.dart';

class FirstEntryScreen extends StatelessWidget {
  final cubit = UserLoadingCubit();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[500],
      ),
      body: BlocBuilder(
        bloc: cubit,
        builder: (BuildContext context, state) {
          if (state is UserLoadingProgressState)
            return LoadingUsersProgressWidget();
          else if (state is UserLoadingErrorState)
            return ErrorWhileLoading(cubit.loadUsers);
          else
            return LoadingUsersComplete();
        },
      ),
    );
  }
}
