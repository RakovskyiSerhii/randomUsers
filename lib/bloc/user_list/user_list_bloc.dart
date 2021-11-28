import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_users/core/data/models/UserModel.dart';
import 'package:random_users/core/data/repository.dart';

part 'user_list_state.dart';
part 'user_list_event.dart';

class UserListBloc extends Bloc<UserListEvent, UserListState> {
  final _repository = DataRepository();

  UserListBloc() : super(UserListLoadingState()) {
    on<UserListEvent>(_onEvent);
    add(LoadUsersEvent());
  }

  void _onEvent(UserListEvent event, Emitter emit) async {
    if (event is LoadUsersEvent)
      await _loadUsers(emit);
    else if (event is RefreshUsersEvent)
      await _refreshUsers(emit);
    else if (event is OpenUserEvent)
      emit(UserOpenState(event.userModel));
    else if (event is CreateUserEvent)
      emit(CreateUserState());
    else if (event is RemoveUserEvent) await _removeUser(
        event.userModel, event.removeFromDB, emit);
  }

  Future _removeUser(UserModel user, bool removeFromDB, Emitter emit) async {
    if (state is UserListRetrievedState) {
      final UserListRetrievedState oldState = state as UserListRetrievedState;
      oldState.list.remove(user);
      if (removeFromDB) {
        await _repository.removeUser(user);
      }
      emit(UserListRetrievedState(oldState.list));
    }
  }

  Future _loadUsers(Emitter emit) async {
    emit(UserListLoadingState());
    final results = await _repository.getUsers();
    emit(UserListRetrievedState(results));
  }

  Future _refreshUsers(Emitter emit) async {
    emit(UserListLoadingState());
    await _repository.refreshUsers();
    final results = await _repository.getUsers();
    emit(UserListRetrievedState(results));
  }
}
