import 'package:flutter/material.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:random_users/core/ui/widgets/error_while_loading.dart';
import 'package:random_users/core/ui/widgets/loadingUsers_complete.dart';
import 'package:random_users/core/ui/widgets/loading_users_progress.dart';
import 'package:random_users/triple/first_entry_store.dart';

class FirstEntryTriple extends StatelessWidget {
  final FirstEntryStore _store = FirstEntryStore()..loadUsers();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScopedBuilder(
        store: _store,
        onLoading: (_) => LoadingUsersProgressWidget(),
        onState: (_, __) => LoadingUsersComplete(),
        onError: (_, __) => ErrorWhileLoading(_store.loadUsers),
      ),
    );
  }
}
