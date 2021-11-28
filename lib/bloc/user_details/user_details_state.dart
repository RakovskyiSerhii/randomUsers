part of 'user_details_cubit.dart';

@immutable
abstract class UserDetailsInitialState {}

class UserDetailsState extends UserDetailsInitialState {
  final UserModel userModel;

  UserDetailsState(this.userModel);
}

class CreateUserDetailsState extends UserDetailsInitialState {}
class UserSavedState extends UserDetailsState {
  UserSavedState(UserModel userModel) : super(userModel);
}