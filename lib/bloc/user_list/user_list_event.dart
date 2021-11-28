part of 'user_list_bloc.dart';

@immutable
abstract class UserListEvent {}

class LoadUsersEvent extends UserListEvent {}
class RefreshUsersEvent extends UserListEvent {}
class CreateUserEvent extends UserListEvent {}
class OpenUserEvent extends UserListEvent {
  final UserModel userModel;

  OpenUserEvent(this.userModel);
}

class RemoveUserEvent extends UserListEvent {
  final UserModel userModel;
  final bool removeFromDB;
  RemoveUserEvent(this.userModel, {this.removeFromDB = true});
}