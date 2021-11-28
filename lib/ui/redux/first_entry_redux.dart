import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:random_users/core/ui/widgets/error_while_loading.dart';
import 'package:random_users/core/ui/widgets/loadingUsers_complete.dart';
import 'package:random_users/core/ui/widgets/loading_users_progress.dart';
import 'package:random_users/redux/actions.dart';
import 'package:random_users/redux/app_state.dart';

class FirstEntryRedux extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoreConnector<AppState, FirstEntryViewModel>(
        onInit: (store) => store.dispatch(LoadListAction()),
        builder: (BuildContext context, FirstEntryViewModel viewModel) {
          if (viewModel.loadComplete)
            return LoadingUsersComplete();
          else if (viewModel.errorWhileLoading)
            return ErrorWhileLoading(viewModel.onRefresh);
          else
            return LoadingUsersProgressWidget();
        },
        converter: (store) {
          final state = store.state;
          return FirstEntryViewModel(state.isLoading, state.usersLoaded,
              state.usersLoaded && state.users == null, () {
            store.dispatch(LoadListAction());
          });
        },
      ),
    );
  }
}

class FirstEntryViewModel {
  final bool isLoading;
  final bool loadComplete;
  final VoidCallback onRefresh;
  final bool errorWhileLoading;

  FirstEntryViewModel(this.isLoading, this.loadComplete, this.errorWhileLoading,
      this.onRefresh);
}
