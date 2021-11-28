part of 'user_list_bloc.dart';

@immutable
abstract class UserListState {}

class UserListLoadingState extends UserListState {}

class UserListRetrievedState extends UserListState {
  final List<UserModel> list;

  UserListRetrievedState(this.list);
}

class UserLoadingErrorState extends UserListState {}
class UserOpenState extends UserListState {
  final UserModel userModel;

  UserOpenState(this.userModel);
}
class CreateUserState extends UserListState{}